#include<iostream>
#include<fstream>
#include<cstdlib>
#include<string>
#include<sstream>
#include<vector>
#include<utility>
#include <unordered_map>
#include<algorithm>
#include<stdlib.h>
#include<cassert>
#include<math.h>
#include <sys/types.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <boost/algorithm/string.hpp>
#include <boost/tokenizer.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/unordered_map.hpp>
#include <omp.h>
#include<chrono>
#include<ctime>

#include "constants.h"
#include "fault_c.h"

int main(int argc, char* argv[]){

	auto start = std::chrono::system_clock::now();	
	
	auto end = std::chrono::system_clock::now();
	auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(end - start);
	
	std::cout << "START TIME:\t" << elapsed.count() << std::endl; 
		
	std::string name = argv[1], line, node, cmd;
	bool flag = 0;
	// This file inputs bench file.	
	std::vector<std::string> nodeList;
	std::ifstream bench(("/home/projects/aspdac18/files/benchfiles/"+name+".bench").c_str());
	std::cout<<"benchfile name: "<<name<<std::endl;	
    cmd = "cd /home/projects/aspdac18/files/benchfiles/; abc -c \"read_bench "+name+".bench; write_verilog "+name+".v\"";
    system(cmd.c_str());        
	if(bench.fail()){
		std::cerr<<"BENCH FILE OPEN FAILED"<<std::endl;
		exit(1);
	}

	while(getline(bench, line)){
		if(line.find("=")!=-1){
			int pos = line.find("=");
			node = line.substr(0, pos-1);
			nodeList.push_back(node);
		}
	}

	// Create a new folder in Results with the bench file name
	cmd =  "rm -rf /home/projects/aspdac18/Results/"+name+"/";
	system(cmd.c_str());
	cmd =  "mkdir -p /home/projects/aspdac18/Results/"+name+"/";
	system(cmd.c_str());

	std::cout<<"CREATING FOLDERS"<<std::endl;
	// Create nodeList folders in each benchfile folder
	// For parallel runs

	//omp_lock_t writelock;
	//omp_init_lock(&writelock);
	//#pragma omp parallel for schedule(dynamic) num_threads(32)
	for(int i=0; i<nodeList.size(); i++){
        std::string cmd1 = "mkdir -p /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/";
        system(cmd1.c_str());
        std::ofstream flt(("/home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/fault.flt").c_str());
        // check only for stuck-at-0 fault. For sa1 fault change it to /1.
        flt << nodeList[i] << " /0" << std::endl;
	}
	// Atalanta begins and iterated over  all nodes in the benchfile
	std::cout<<"ATALANTA START"<<std::endl;

	//omp_lock_t writelock;
    //omp_init_lock(&writelock);

    #pragma omp parallel for schedule(dynamic) num_threads(32)
	for(int i=0; i<nodeList.size(); i++){
		std::cout<<"i:	"<<i<<std::endl;
		std::string path_link = "/home/projects/aspdac18/Results/"+name+"/path_link"+boost::lexical_cast<std::string>(i);
        std::string cmd2 = "ln -s /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+" "+path_link;
		system(cmd2.c_str());
		// ************ run atalanta for 10 secs, so that around 1 million test patterns are already collected, which are enough. It generates fault and patterns file along with log file. If it takes more than 10 secs to generate all the test patterns, then log file will not be generated fro that node. 
		cmd2 = "timeout 10 atalanta -A -f "+path_link+"/fault.flt -t "+path_link+"/patterns.pat /home/projects/aspdac18/files/benchfiles/"+name+".bench > "+path_link+"/log ";
		std::cout << cmd2 << std::endl;
		system(cmd2.c_str());
    }

    std::cout<<"ATALANTA END"<<std::endl;

    sleep(10);

	std::vector<fault_c*> validList, passList;

	std::cout<<"COMPUTING VALIDLIST"<<std::endl;

	int sec_max = 0;
    
    // Find all the valid/secure nodes above the said security SEC

	omp_lock_t writelock;
    omp_init_lock(&writelock);
    #pragma omp parallel for schedule(dynamic) num_threads(10)
	for(int i=0; i<nodeList.size(); i++){
		std::cout<< (double)i/(double)nodeList.size()*100<< "\% node: " << nodeList[i] << std::endl;
		std::ifstream log(("/home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/log").c_str());
		std::ifstream patt(("/home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/patterns.pat").c_str());
			
		if(log.peek() != std::ifstream::traits_type::eof() /*true*/){
			fault_c *f = new fault_c(nodeList[i], patt);
			if(f->getSec() >= SEC) {
                omp_set_lock(&writelock);
				validList.push_back(f);
                std::cout<<"ValidList Node: "<<nodeList[i]<<", Security: "<<f->getSec()<<std::endl;
                omp_unset_lock(&writelock);
			}
            else{
                // Remove node if not used
                f->removeNode(name);
                delete f;
            }
		}
	}
	std::cout<<"Valid List Size:	"<<validList.size()<<std::endl;

	int final_node_ind = 0;
	for(int i=0; i<validList.size(); i++){
		std::cout<<"\% COMPLETE "<< (double)i/(double)validList.size()*100<<" "<<validList[i]->node << ":" << i << ", SEC " << validList[i]->getSec() << std::endl;
		std::cout<<"ValidList Node:	"<<validList[i]->node<<std::endl;
                
        std::string path = "/home/projects/aspdac18/Results/"+name+"/"+validList[i]->node;
		std::string bench_path = "/home/projects/aspdac18/files/benchfiles/";
        std::ofstream verilog((path+"/verilog.v").c_str());

		std::ifstream orig(("/home/projects/aspdac18/files/benchfiles/"+name+".v").c_str());
        // Make sure the names of the benchfile and verilog match. Also the module name is same as that of the file name.
        if(orig.fail()){
                std::cerr<<"ORIG VERILOG OPEN FAILED"<<std::endl;
                continue;
        }
        std::string line;
        // The following code replaces the stuck at 0 locations with 1'b0... Removes the logic eg. c = a&b. Replaces it with assign c = 1'b0.
		while(getline(orig, line)){
            if(line.find("assign "+validList[i]->node+" =")!=std::string::npos){
                    verilog << "assign "<<validList[i]->node<<" = 1'b0;"<<std::endl;
            }
            else    verilog<<line<<std::endl;
		}
	
		// Optimize 1'b0 with ABC
		std::string cmd = "abc -c \"read_verilog "+path+ "/verilog.v; sweep; strash; refactor; logic; sweep; write_verilog "+path+"/abc_verilog.v\"";
        system(cmd.c_str());

		std::cout << "i: " << i << std::endl;
	
		//validList[i]->recoverOnePattCkt("/home/projects/aspdac18/Results/"+name);
		validList[i]->modifyOrigWithOnePatt(name, "/home/projects/aspdac18/Results/"+name);
        // Parse the module name to remove leading ../../ etc.
		//cmd = "cat /home/projects/aspdac18/Results/"+name+"/"+validList[i]->node+"/lockOnePatt_verilog.v | awk '{gsub(/\\\\files\\//,\"\"); print}' > /home/projects/aspdac18/Results/"+name+"/"+validList[i]->node+"/"+name+".v";
	        
        //system(cmd.c_str());
		//bool check_eq = validList[i]->checkEqv(name);
		//std::cout << "check_equivalent: " << check_eq << std::endl;
        if(!validList[i]->checkEqv(name)){
            validList[i]->doEco(name);
            validList[i]->ecoCompile(name);
            validList[i]->addRestoreCkt(name, "/home/projects/aspdac18/Results/"+name);
            if(validList[i]->checkKeyConstraint(name)){
                std::cout<<"The NODE which attained security is: 	"<<validList[i]->node<<std::endl;
                //validList[i]->postProcesslockedVerilog(name);
            }
        } 
	    //if(!check_eq){
        //    validList[i]->doEco(name);
        //    //std::cout << "Node for ECO:" << validList[i]->node<< std::endl;
        //    //exit(0);
        //    if (validList[i]->checkKeyConstraint(name)){
        //        end = std::chrono::system_clock::now();
        //        elapsed = std::chrono::duration_cast<std::chrono::seconds>(end - start);
        //        std::cout << "Fault search end: " << elapsed.count() << std::endl;
        //        std::cout<<"The NODE which attained security is: 	"<<validList[i]->node<<std::endl;
        //        final_node_ind = i;
        //        cmd = "mkdir ../../Results/"+name+"/final";
        //        system(cmd.c_str());
        //        cmd = "cp ../../Results/"+name+"/"+validList[i]->node+"/* ../../Results/"+name+"/final/";
        //        system(cmd.c_str());

        //        validList[i]->postProcesslockedVerilog(name);
        //
        //        std::cout<<"EQUIVALENCE BETWEEN LOCKED AND ORIGINAL CHECK"<<std::endl;	
        //        flag = validList[i]->checkEqvOrigLock(name);
        //        if(flag) 
        //            break;
        //        else 
        //            std::cout<<"================ LOCKED FILE IS NON-EQUIVALENT =================="<<std::endl;
        //        
        //    } 
        //    else{
        //        validList[i]->removeNode(name);
        //    }
        //}
        //else {
        //    std::cout<<"================ THE FILES ARE EQUIVALENT =================="<<std::endl;
        //}
	}

	if (flag) {
		validList[final_node_ind]->generateAPD(name);
	}
	else {
		std::cout<<"============ 	NO NODE SATISFYING TARGET SECURITY FOUND 	==============="<<std::endl;
	}

	end = std::chrono::system_clock::now();
    elapsed = std::chrono::duration_cast<std::chrono::seconds>(end - start);

    std::cout << "ELAPSED TIME:\t" << elapsed.count() << std::endl;	
	return 0;
}


