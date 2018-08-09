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

#include "constants.h"
#include "fault_c.h"
#include<chrono>
#include<ctime>

bool comp(fault_c* lhs, fault_c* rhs){
	return lhs->getOnePattCost() > rhs->getOnePattCost();
}
int main(int argc, char* argv[]){

	auto start = std::chrono::system_clock::now();	

	std::string name = argv[1], line, node, cmd;
	std::vector<std::string> nodeList;
	std::ifstream bench(("/home/projects/aspdac18/files/"+name+".bench").c_str());
	
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

	cmd =  "rm -rf /home/projects/aspdac18/Results/"+name+"/";
	system(cmd.c_str());
	cmd =  "mkdir -p /home/projects/aspdac18/Results/"+name+"/";
	system(cmd.c_str());

	std::cout<<"CREATING FOLDERS"<<std::endl;
	
	for(int i=0; i<nodeList.size(); i++){
		cmd = "mkdir -p /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/";
		system(cmd.c_str());
		std::ofstream flt(("/home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/fault.flt").c_str());
		flt << nodeList[i] << " /0" << std::endl;
	}
	
	std::cout<<"ATALANTA START"<<std::endl;
	for(int i=0; i<nodeList.size(); i++){
		std::string path_link = "path_link"+boost::lexical_cast<std::string>(i);
		cmd = "ln -s /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+" "+path_link;
		system(cmd.c_str());
		cmd = "timeout 10 atalanta -A -f "+path_link+"/fault.flt -t "+path_link+"/patterns.pat /home/projects/aspdac18/files/"+name+".bench > "+path_link+"/log &";
		//std::cout << cmd << std::endl;
		//cmd = "timeout 10 atalanta -A -f /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/fault.flt -t /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/patterns.pat /home/projects/aspdac18/files/"+name+".bench > /home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/log &";
		system(cmd.c_str());
        }

        std::cout<<"ATALANTA END"<<std::endl;

        sleep(10);

	std::vector<fault_c*> validList, passList;

	std::cout<<"COMPUTING VALIDLIST"<<std::endl;

	int sec_max = 0;

	for(int i=0; i<nodeList.size(); i++){
		std::cout<< (double)i/(double)nodeList.size()*100<< "\% node: " << nodeList[i] << std::endl;
		std::ifstream log(("/home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/log").c_str());
		std::ifstream patt(("/home/projects/aspdac18/Results/"+name+"/"+nodeList[i]+"/patterns.pat").c_str());
		if(log.peek() != std::ifstream::traits_type::eof() /*true*/){
			fault_c *f = new fault_c(nodeList[i], patt);
			if(f->getNumPatt() <= MAX_PAT && f->getSec() >= SEC){
				validList.push_back(f);
				break;
				//std::cout<< "sec: " << f->getSec() << std::endl;
			}
			if(f->getSec() > sec_max)
				sec_max = f->getSec();
			else	delete f;
		}
		//else std::cout << "skipped: no log file" <<std::endl;
		std::cout<< "cur max sec: " << sec_max << std::endl;
	}

	std::cout<<"% VALID: "<<validList.size()/(double)nodeList.size()*100<<std::endl;

	//exit(0);

	int max = 0, index = 0;
        for(int i=0; i<validList.size(); i++){
 	       if(validList[i]->getSec() > max){
                        index = i;
                        max = validList[i]->getSec();
                }
        }
	
	std::cout << "max sec: " << max << " node: "<< validList[index]->node << std::endl;

	//exit(0);

	for(int i=0; i<validList.size(); i++){
		std::cout<<"\% COMPLETE "<< (double)i/(double)validList.size()*100<<" "<<validList[i]->node << ":" << i << ", SEC " << validList[i]->getSec() << std::endl;
                
                std::string path = "/home/projects/aspdac18/Results/"+name+"/"+validList[i]->node;

                std::ofstream verilog((path+"/verilog.v").c_str());

                std::ifstream orig(("/home/projects/aspdac18/files/"+name+".v").c_str());

                if(orig.fail()){
                        std::cerr<<"ORIG VERILOG OPEN FAILED"<<std::endl;
                        continue;
                }
                std::string line;
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

	}	

	int min = 99999;
	 index = 0;
        for(int i=0; i<validList.size(); i++){
 	       if(validList[i]->getOnePattCost() < min){
                        index = i;
                        min = validList[i]->getOnePattCost();
                }
        }

	std::cout<<"OPT NODE: "<<validList[index]->node<<" SEC:"<< validList[index]->getLeastSec() << " COST: " << validList[index]->getOnePattCost() <<std::endl;

	auto end = std::chrono::system_clock::now();
        auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(end - start);

        std::cout << "ELAPSED TIME:\t" << elapsed.count() << std::endl;	
	
	validList[index]->recoverOnePattCkt("/home/projects/aspdac18/Results/"+name);
	cmd = "mkdir -p /home/projects/aspdac18/Results/"+name+"/final/";
	system(cmd.c_str());
	cmd = "cp /home/projects/aspdac18/Results/"+name+"/"+validList[index]->node+"/lockOnePatt_verilog.v /home/projects/aspdac18/Results/"+name+"/final/"+name+"_init.v";
	system(cmd.c_str());
	
	cmd = "cat /home/projects/aspdac18//Results/"+name+"/final/"+name+"_init.v | awk '{gsub(/\\\\files\\//,\"\"); print}' > /home/projects/aspdac18//Results/"+name+"/final/"+name+".v";
	system(cmd.c_str());

	validList[index]->doEco(name);
	validList[index]->checkKeyConstraint(name);
	std::cout << "key constraint check" << std::endl;
	std::cout << "sec attained: " << validList[index]->getNumValidKey() << std::endl;

	end = std::chrono::system_clock::now();
        elapsed = std::chrono::duration_cast<std::chrono::seconds>(end - start);

        std::cout << "ELAPSED TIME 2:\t" << elapsed.count() << std::endl;	
	return 0;
}


