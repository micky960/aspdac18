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
#include "constants.h"
#include "fault_c.h"
#include<chrono>
#include<ctime>

bool comp(fault_c* lhs, fault_c* rhs){
	return lhs->getOnePattCost() > rhs->getOnePattCost();
}

int fa_usage(const char* progname)
{
    std::cout << "Usage: " << progname << " [options] <bench-file>"<< std::endl;
    std::cout << "Options may be one of the following." << std::endl;
    std::cout << "    -h            : this message." << std::endl;
    std::cout << "    -i            : benchfile name." << std::endl;
    std::cout << "    -k            : key size." << std::endl;
//    std::cout << "    -o <filename> : output file." << std::endl;
//    std::cout << "    -k <keys>     : number of keys to introduces (default=10% of num_gates)." << std::endl;
//    std::cout << "    -c <value>    : CPU time limit (s)." << std::endl;
//    std::cout << "    -m <value>    : mem usage limit (MB)." << std::endl;
    return 0;
}

int main(int argc, char* argv[]){

	auto start = std::chrono::system_clock::now();	
	
	std::string name = argv[1], line, node, cmd;
	bool flag = 0;
	//int c;
	//while ((c = getopt (argc, argv, "ihk")) != -1) {
        //	switch (c) {
        //    		case 'h':
        //        		return fa_usage(argv[0]);
        //        		break;

    	//	case 'i':
	//			name = argv[2];
	//			break;
	//		default:
	//			break;
	//	}
	//}        
	// This file inputs bench file.	
	std::vector<std::string> nodeList;
	std::ifstream bench(("/home/projects/aspdac18/files/benchfiles/"+name+".bench").c_str());
	
	//if(name=="-help"){
	//	std::cout<<"-i: provide design name or the benchfile name."<<std::endl;
	//}
	//
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
	// create a new folder in Results with the bench file name
	cmd =  "rm -rf /home/projects/aspdac18/Results/"+name+"/";
	system(cmd.c_str());
	cmd =  "mkdir -p /home/projects/aspdac18/Results/"+name+"/";
	system(cmd.c_str());

	std::cout<<"CREATING FOLDERS"<<std::endl;
	// create nodeList folders in each benchfile folder
        

	// for parallel runs

	//omp_lock_t writelock;
	//omp_init_lock(&writelock);

	//#pragma omp parallel for schedule(dynamic) num_threads(10)
	for(int i=0; i<nodeList.size(); i++){
		cmd = "mkdir -p /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/";
		system(cmd.c_str());
		std::ofstream flt(("/home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/fault.flt").c_str());
		// check only for stuck-at-0 fault. For sa1 fault change it to /1.
	
		flt << nodeList[i] << " /0" << std::endl;
	}
	//exit(0);
	// Atalanta begins and iterated over  all nodes in the benchfile
	std::cout<<"ATALANTA START"<<std::endl;

	//omp_lock_t writelock;
        //omp_init_lock(&writelock);
       // #pragma omp parallel for schedule(dynamic) num_threads(10)

	for(int i=0; i<nodeList.size(); i++){
		std::string path_link = "/home/projects/aspdac18/Results/"+name+"/path_link"+boost::lexical_cast<std::string>(i);
		cmd = "ln -s /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+" "+path_link;
		system(cmd.c_str());
		// ************ run atalanta for 10 secs, so that around 1 million test patterns are already collected, which are enough. It generates fault and patterns file along with log file. If it takes more than 10 secs to generate all the test patterns, then log file will not be generated fro that node. 
		cmd = "timeout 10 atalanta -A -f "+path_link+"/fault.flt -t "+path_link+"/patterns.pat /home/projects/aspdac18/files/benchfiles/"+name+".bench > "+path_link+"/log &";
		//std::cout << cmd << std::endl;
		//cmd = "timeout 10 atalanta -A -f /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/fault.flt -t /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/patterns.pat /home/projects/aspdac18/files/"+name+".bench > /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/log &";
		system(cmd.c_str());
        }

        std::cout<<"ATALANTA END"<<std::endl;

        sleep(10);

	std::vector<fault_c*> validList, passList;

	std::cout<<"COMPUTING VALIDLIST"<<std::endl;

	//std::cout << "node list size: "<<nodeList.size()<<std::endl;
	int sec_max = 0;
// Find all the valid/secure nodes above the said security SEC

//	omp_lock_t writelock;
//       omp_init_lock(&writelock);
//        #pragma omp parallel for schedule(dynamic) num_threads(5)

	for(int i=0; i<nodeList.size(); i++){
		std::cout<< (double)i/(double)nodeList.size()*100<< "\% node: " << nodeList[i] << std::endl;
		std::ifstream log(("/home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/log").c_str());
		std::ifstream patt(("/home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/patterns.pat").c_str());
		// log.peek() checks if a log file was created for the node i...
	//	std::cout<<"Entered FOR loop"<<std::endl;
			
		if(log.peek() != std::ifstream::traits_type::eof() /*true*/){
			fault_c *f = new fault_c(nodeList[i], patt);
	//		std::cout<<"Entered IF"<<std::endl;
			//std::cout<<f->getSec()<<std::endl;
			// if f is greater than SEC <defined in constants.h file>, then f gets added to the validList and comes out of the loop.
//			if(f->getNumPatt() <= MAX_PAT && f->getSec() >= SEC){
			if(f->getSec() >= SEC) {
				validList.push_back(f);
//				std::cout<<"ValidList Node:     "<<validList[i]->node<<std::endl;
                                std::cout<<"ValidList Node:     "<<nodeList[i]<<std::endl;
				std::cout<<f->getSec()<<std::endl;

				//
	                //Nimisha Commented this 
                	//break;
				//std::cout<< "sec: " << f->getSec() << std::endl;
			}
	//		if(f->getSec() > sec_max)
	//			sec_max = f->getSec();
// Commented the else part so that correct values are stored in the validList vector.
//			else	delete f;
		}
//		std::cout<<"ValidList Node:     "<<validList[i]->node<<std::endl;
		//else std::cout << "skipped: no log file" <<std::endl;
	//	std::cout<< "cur max sec: " << sec_max << std::endl;
	}
	std::cout<<"Valid List Size:	"<<validList.size()<<std::endl;
	// ######### Gives incorect values in validList vector ###########

	// gives the valid nodes percentage whose security is above that of SEC
	//std::cout<<"% VALID: "<<validList.size()/(double)nodeList.size()*100<<std::endl;

	//exit(0);
	// the following for loop identifies node which has the most security.

	//int max = 0, index = 0;
        //for(int i=0; i<validList.size(); i++){
	//       if(validList[i]->getSec() > max){
        //                index = i;
        //                max = validList[i]->getSec();

        //        }
        //}
	
	//std::cout << "max sec: " << max << " node: "<< validList[index]->node << std::endl;
	//exit(0);
	

//	for (int i=0; i<nodeList.size();i++){
//		std::cout<<"ValidList Node:     "<<validList[i]->node<<std::endl;
//	}
//	exit(0);
	int final_node_ind = 0;
	for(int i=0; i<validList.size(); i++){
		std::cout<<"\% COMPLETE "<< (double)i/(double)validList.size()*100<<" "<<validList[i]->node << ":" << i << ", SEC " << validList[i]->getSec() << std::endl;
		std::cout<<"ValidList Node:	"<<validList[i]->node<<std::endl;
                
                std::string path = "/home/projects/aspdac18/Results/"+name+"/"+validList[i]->node;
		std::string bench_path = "/home/projects/aspdac18/files/benchfiles/";
                std::ofstream verilog((path+"/verilog.v").c_str());
		//std::string cmd = "abc -c \"read_bench "+bench_path+name+".bench; write_verilog "+bench_path+name+".v\"";

//		std::string cmd = "abc -c \"read_bench /home/projects/aspdac18/files/benchfiles/"+name+".bench; write_verilog /home/projects/aspdac18/files/benchfiles/"+name+".v\"";
        	system(cmd.c_str());        
		std::ifstream orig(("/home/projects/aspdac18/files/benchfiles/"+name+".v").c_str());
		// make sure the names of the benchfile and verilog match. Also the module name is same as that of the file name.
                if(orig.fail()){
                        std::cerr<<"ORIG VERILOG OPEN FAILED"<<std::endl;
                        continue;
                }
	//	exit(0);
                std::string line;
                // the following code replaces the stuck at 0 locations with 1'b0... Removes the logic eg. c = a&b. Replaces it with assign c = 1'b0.
		while(getline(orig, line)){
                        if(line.find("assign "+validList[i]->node+" =")!=std::string::npos){
                                verilog << "assign "<<validList[i]->node<<" = 1'b0;"<<std::endl;
                        }
                        else    verilog<<line<<std::endl;
                
		}
	
		//validList[i]->recoverOnePattCkt("/home/as9397/tapeout/Results/"+name);	
		
		//##########WRITE CODE FOR DC SYNTHESIS###########
		std::string cmd = "abc -c \"read_verilog "+path+ "/verilog.v; sweep; strash; refactor; logic; sweep; write_verilog "+path+"/abc_verilog.v\"";
                system(cmd.c_str());

		//validList[i]->synthFICkt(name);	
		std::cout << "i:	" << i << std::endl;
	//	i = i+1;
	
		validList[i]->recoverOnePattCkt("/home/projects/aspdac18/Results/"+name);
		//exit(0);
	       // cmd = "mkdir -p /home/projects/aspdac18/Results/"+name+"/final/";
	        //system(cmd.c_str());
//	        cmd = "cp /home/projects/aspdac18/Results/"+name+"/"+validList[i]->node+"/lockOnePatt_verilog.v /home/projects/aspdac18/Results/"+name+"/final/"+name+"_init.v";
//	        system(cmd.c_str());
		cmd = "cat /home/projects/aspdac18//Results/"+name+"/"+validList[i]->node+"/lockOnePatt_verilog.v | awk '{gsub(/\\\\files\\//,\"\"); print}' > /home/projects/aspdac18//Results/"+name+"/"+validList[i]->node+"/"+name+".v";
	        
//	        cmd = "cat /home/projects/aspdac18//Results/"+name+"/final/"+name+"_init.v | awk '{gsub(/\\\\files\\//,\"\"); print}' > /home/projects/aspdac18//Results/"+name+"/final/"+name+".v";
	        system(cmd.c_str());
//		std::string node_name = validList[i]->node;	
		bool check_eq = validList[i]->checkEqv(name);
		std::cout << "check_equivalent: " << check_eq << std::endl;
	        if(!validList[i]->checkEqv(name)){
			validList[i]->doEco(name);
	        	validList[i]->checkKeyConstraint(name);
	 	        std::cout << "key constraint check" << std::endl;
	       		std::cout << "sec attained: " << validList[i]->getNumValidKey() << std::endl;
//			exit(1);	
			cmd = "dc_shell-t -no_gui -64bit -output_log_file /home/projects/aspdac18/Results/"+name+"/final/locked_verilog.log -x \"source -echo -verbose ../scripts/locked_verilog.tcl \" ";
                	system(cmd.c_str());

			if (validList[i]->getNumValidKey() >= TARGET_SEC){
				std::cout<<"The NODE which attained security is: 	"<<validList[i]->node<<std::endl;
				//final_node_ind = i;
				cmd = "mkdir ../../Results/"+name+"/final";
				system(cmd.c_str());
				cmd = "cp ../../Results/"+name+"/"+validList[i]->node+"/"+name+"_final_combo.v ../../Results/"+name+"/final/"+name+"_final_combo.v";
			        system(cmd.c_str());
				cmd = "cp ../../Results/"+name+"/"+validList[i]->node+"/"+name+"_final_combo.sdc ../../Results/"+name+"/final/"+name+"_final_combo.sdc";
                                system(cmd.c_str());
				cmd = "cp ../../Results/"+name+"/"+validList[i]->node+"/key.tcl ../../Results/"+name+"/final/key.tcl";
                                system(cmd.c_str());
				flag = 1;
				break;
			}
		}else {
			std::cout<<"================ THE FILES ARE EQUIVALENT =================="<<std::endl;
		}
	}

	if (flag) {
		cmd = "dc_shell-t -no_gui -64bit -output_log_file /home/projects/aspdac18/Results/"+name+"/final/apd_analysis.log -x \"source -echo -verbose ../scripts/generate_apd.tcl \" ";
        	system(cmd.c_str());
	}
	else {
		std::cout<<"============ 	NO NODE SATISFYING TARGET SECURITY FOUND 	==============="<<std::endl;
	}

//	exit(0)	;


//	std::cout << "outside for loop" << std::endl;
	//int min = 99999;
	//int index = 0;
        //for(int i=0; i<validList.size(); i++){
// 	       if(validList[i]->getOnePattCost() < min){
//                        index = i;
//                        min = validList[i]->getOnePattCost();
//                }
//        }
//
//	std::cout<<"OPT NODE: "<<validList[index]->node<<" SEC:"<< validList[index]->getLeastSec() << " COST: " << validList[index]->getOnePattCost() <<std::endl;
//
//	auto end = std::chrono::system_clock::now();
//        auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(end - start);
//
//        std::cout << "START TIME:\t" << elapsed.count() << std::endl;	
//	
//	validList[index]->recoverOnePattCkt("/home/projects/aspdac18/Results/"+name);
	//cmd = "mkdir -p /home/projects/aspdac18/Results/"+name+"/final/";
	//system(cmd.c_str());
	//cmd = "cp /home/projects/aspdac18/Results/"+name+"/"+validList[index]->node+"/lockOnePatt_verilog.v /home/projects/aspdac18/Results/"+name+"/final/"+name+"_init.v";
	//system(cmd.c_str());
	
	//cmd = "cat /home/projects/aspdac18//Results/"+name+"/final/"+name+"_init.v | awk '{gsub(/\\\\files\\//,\"\"); print}' > /home/projects/aspdac18//Results/"+name+"/final/"+name+".v";
	//system(cmd.c_str());

//	validList[index]->doEco(name);
//	validList[index]->checkKeyConstraint(name);
	//std::cout << "key constraint check" << std::endl;
	//std::cout << "sec attained: " << validList[index]->getNumValidKey() << std::endl;

	//end = std::chrono::system_clock::now();
        //elapsed = std::chrono::duration_cast<std::chrono::seconds>(end - start);

        //std::cout << "ELAPSED TIME 2:\t" << elapsed.count() << std::endl;	
	return 0;
}


