#include "fault_c.h"

fault_c::fault_c(std::string n, std::ifstream& flt){

	node = n;

	std::string line;
	while(line.find("* Primary inputs")==std::string::npos){
		getline(flt, line);
	}
	getline(flt, line);
	while(line.find("* Primary outputs")==std::string::npos){
		typedef boost::tokenizer<boost::char_separator<char> > tokenizer;
		boost::char_separator<char> sep(" ");
		tokenizer tokens(line, sep);
		for (tokenizer::iterator tok_iter = tokens.begin(); tok_iter != tokens.end(); ++tok_iter){
			ipList.push_back(*tok_iter);
		}
		getline(flt, line);
	}
	getline(flt, line);
	while(line.find("* Test patterns and fault free responses:")==std::string::npos){
		typedef boost::tokenizer<boost::char_separator<char> > tokenizer;
		boost::char_separator<char> sep(" ");
		tokenizer tokens(line, sep);
		for (tokenizer::iterator tok_iter = tokens.begin(); tok_iter != tokens.end(); ++tok_iter){
			opList.push_back(*tok_iter);
		}
		getline(flt, line);
	}
	getline(flt, line);
	getline(flt, line);

	while(getline(flt, line)){
		pattern* p = new pattern(line);
		pList.push_back(p);
	}

	 _compSec();
         _compOpFailList();
         _getLeastSec();
	_getMaxSec();
}

bool fault_c::checkEqv(std::string name){

	setenv("DESIGN", name.c_str(), 1);
	setenv("NODE", node.c_str(), 1);

	std::string cmd = "lec_64 -nogui -dofile ../scripts/lec_compare.do";
	system(cmd.c_str());

	
	std::ifstream lec(("/home/projects/aspdac18/Results/"+name+"/"+node+"/lec_report").c_str());
	std::string line;
	while(getline(lec, line)){
		if(line.find("Non-equivalent ") != std::string::npos)
			return false;
	}	

	return true;

}

void fault_c::recoverCkt(std::string path){

	std::ifstream vFile((path+"/"+node+"/abc_verilog.v").c_str());
	//std::ifstream vFile((path+"/"+node+"/verilog.v").c_str());
        std::ofstream lockFile((path+"/"+node+"/lock_verilog.v").c_str());

        if(vFile.fail()){
                std::cerr<<"OPT ABC FILE OPEN FAILED"<<std::endl;
                exit(1);
        }
        if(lockFile.fail()){
                std::cerr<<"LOCK FILE OPEN FAILED"<<std::endl;
                exit(1);
        }

	std::string line;
        while(getline(vFile, line)){
                if(line.find("assign")!=std::string::npos){
			for(int i=0; i<fResList.size(); i++){
				if(line.find("assign "+opList[fResList[i]->opIndex]+" ") != std::string::npos){
					boost::replace_all(line, opList[fResList[i]->opIndex], opList[fResList[i]->opIndex]+"_temp");
				}
				else if(line.find("assign "+opList[fResList[i]->opIndex]+" ") != std::string::npos){
					boost::replace_all(line, opList[fResList[i]->opIndex], opList[fResList[i]->opIndex]+"_temp");
				}
				else if(line.find("assign "+opList[fResList[i]->opIndex]+" ") != std::string::npos){
					boost::replace_all(line, opList[fResList[i]->opIndex], opList[fResList[i]->opIndex]+"_temp");
				}
				else if(line.find("assign "+opList[fResList[i]->opIndex]+" ") != std::string::npos){
					boost::replace_all(line, opList[fResList[i]->opIndex], opList[fResList[i]->opIndex]+"_temp");
				}
			}		
		}	
		if(line.find("endmodule")==std::string::npos)
                        lockFile<<line<<std::endl;
	}

	std::vector<std::string> compList, keyList, nvmList;	

	for(int i=0; i<pList.size(); i++){
		std::string comp = "wire ["+boost::lexical_cast<std::string>(pList[i]->iIndex.size()-1)+":0] compPatt_"+boost::lexical_cast<std::string>(i)+ "= {";
		for(int j=0; j<pList[i]->iIndex.size(); j++){
			comp += ipList[pList[i]->iIndex[j]]+", ";
		}
		comp += "};";
		boost::replace_all(comp, ", }","}");
		compList.push_back(comp);
		lockFile << comp << std::endl;

		std::string key = "wire ["+boost::lexical_cast<std::string>(pList[i]->iIndex.size()-1)+":0] sfllKey_"+boost::lexical_cast<std::string>(i)+";";
		keyList.push_back(key);
		lockFile << key << std::endl;

                std::string nvm = "nvm_"+boost::lexical_cast<std::string>(i)+" #(.N("+boost::lexical_cast<std::string>(pList[i]->iIndex.size())+")) nvm_inst"+boost::lexical_cast<std::string>(i)+"(";
                nvm += ".rdata(sfllKey_"+boost::lexical_cast<std::string>(i)+")";
                nvm += ");\n\n";
                lockFile << nvm <<std::endl;

		std::string nvm_def = "module nvm_"+boost::lexical_cast<std::string>(i)+" #(parameter N = 1) (\n";
                nvm_def += "rdata\n";
                nvm_def += ");\n\n";
                nvm_def += "output [N-1:0] rdata;\n";
		nvm_def += "assign rdata = "+boost::lexical_cast<std::string>(pList[i]->iIndex.size())+"'b";

		for(int j=0; j<pList[i]->iIndex.size(); j++){
			nvm_def += pList[i]->ipPatt[pList[i]->iIndex[j]];
		}

		nvm_def += ";\nendmodule\n";
		
		nvmList.push_back(nvm_def);

	}

	for(int i=0; i<fResList.size(); i++){

		lockFile << "reg " << opList[fResList[i]->opIndex] <<";"<<std::endl;

		std::string always = "always @* begin\n";
		for(int j=0; j<fResList[i]->ipPattIndex.size(); j++){
			always += "if(";
			always += "sfllKey_"+boost::lexical_cast<std::string>(fResList[i]->ipPattIndex[j].first)+" == "+"compPatt_"+boost::lexical_cast<std::string>(fResList[i]->ipPattIndex[j].first)+")\n";
			always += "\t"+opList[fResList[i]->opIndex]+" = 1'b"+fResList[i]->ipPattIndex[j].second+";\n";
			always += "else \t"+opList[fResList[i]->opIndex]+" = "+opList[fResList[i]->opIndex]+"_temp;\n";
		}	
		always += "end\n";
		lockFile << always << std::endl;
	
	}

	lockFile << "endmodule\n" << std::endl;
	for(int i=0; i< nvmList.size(); i++)
		lockFile << nvmList[i] << std::endl;
	
}

void fault_c::recoverOnePattCkt(std::string path){

	std::ifstream vFile((path+"/"+node+"/abc_verilog.v").c_str());
	//std::ifstream vFile((path+"/"+node+"/verilog.v").c_str());
        std::ofstream lockFile((path+"/"+node+"/lockOnePatt_verilog.v").c_str());

        if(vFile.fail()){
                std::cerr<<"OPT ABC FILE OPEN FAILED"<<std::endl;
                exit(1);
        }
        if(lockFile.fail()){
                std::cerr<<"LOCK FILE OPEN FAILED"<<std::endl;
                exit(1);
        }

	pattern *p = pList[maxSecIndex];

	std::string line;
        while(getline(vFile, line)){
                if(line.find("assign")!=std::string::npos){
			for(int i=0; i<p->oIndex.size(); i++){
				if(line.find("assign "+opList[p->oIndex[i]]+" ") != std::string::npos){
					std::cout << opList[p->oIndex[i]] << std::endl;
					std::cout << line << std::endl;
					boost::replace_all(line, opList[p->oIndex[i]], opList[p->oIndex[i]]+"_temp");
					std::cout << line << std::endl;
				}
				else if(line.find("assign "+opList[p->oIndex[i]]+" ") != std::string::npos){
					boost::replace_all(line, opList[p->oIndex[i]], opList[p->oIndex[i]]+"_temp");
				}
				else if(line.find("assign "+opList[p->oIndex[i]]+" ") != std::string::npos){
					boost::replace_all(line, opList[p->oIndex[i]], opList[p->oIndex[i]]+"_temp");
				}
				else if(line.find("assign "+opList[p->oIndex[i]]+" ") != std::string::npos){
					boost::replace_all(line, opList[p->oIndex[i]], opList[p->oIndex[i]]+"_temp");
				}
			}		
		}	
		if(line.find("endmodule")==std::string::npos)
                        lockFile<<line<<std::endl;
	}

	std::vector<std::string> compList, keyList, nvmList;	
	
	
	std::cout<<"NEW INDEX SIZE IS:	"<<p->iIndex.size()<<std::endl;
	std::string comp = "wire ["+boost::lexical_cast<std::string>(p->iIndex.size()-1)+":0] compPatt_"+boost::lexical_cast<std::string>(maxSecIndex)+ "= {";
	for(int i=0; i<p->iIndex.size(); i++){
		comp += ipList[p->iIndex[i]]+", ";
	}
	comp += "};";
	boost::replace_all(comp, ", }","}");
	compList.push_back(comp);
	lockFile << comp << std::endl;
	
	std::string key = "wire ["+boost::lexical_cast<std::string>(p->iIndex.size()-1)+":0] sfllKey_"+boost::lexical_cast<std::string>(maxSecIndex)+";";
	keyList.push_back(key);
	lockFile << key << std::endl;
	
	std::string nvm = "nvm_"+boost::lexical_cast<std::string>(maxSecIndex)+" #(.N("+boost::lexical_cast<std::string>(p->iIndex.size())+")) nvm_inst"+boost::lexical_cast<std::string>(maxSecIndex)+"(";
	nvm += ".rdata(sfllKey_"+boost::lexical_cast<std::string>(maxSecIndex)+")";
	nvm += ");\n\n";
	lockFile << nvm <<std::endl;
	std::ofstream key_file((path+"/"+node+"/key.tcl").c_str());
	key_file << "set KEY {";
	
	std::string nvm_def = "module nvm_"+boost::lexical_cast<std::string>(maxSecIndex)+" #(parameter N = 1) (\n";
	nvm_def += "rdata\n";
	nvm_def += ");\n\n";
	nvm_def += "output [N-1:0] rdata;\n";
	
	nvm_def += "assign rdata = "+boost::lexical_cast<std::string>(p->iIndex.size())+"'b";
	for(int i=0; i<p->iIndex.size(); i++){
		nvm_def += p->ipPatt[p->iIndex[i]];
		key_file << p->ipPatt[p->iIndex[i]]<<" ";
	}
	key_file << "}"<<std::endl;
	
	nvm_def += ";\nendmodule\n";
	
	for(int i=0; i<p->oIndex.size(); i++){
		lockFile << "reg " << opList[p->oIndex[i]] <<";"<<std::endl;
	
		std::string always = "always @* begin\n";
		always += "if(";
		always += "sfllKey_"+boost::lexical_cast<std::string>(maxSecIndex)+" == "+"compPatt_"+boost::lexical_cast<std::string>(maxSecIndex)+")\n";
		always += "\t"+opList[p->oIndex[i]]+" = 1'b"+p->opPatt[p->oIndex[i]]+";\n";
		always += "else \t"+opList[p->oIndex[i]]+" = "+opList[p->oIndex[i]]+"_temp;\n";
		always += "end\n";
		lockFile << always << std::endl;
	}
	lockFile << "endmodule\n" << std::endl;
	
	lockFile << nvm_def << std::endl;
}	

void fault_c::synthFICkt(std::string name){

	setenv("DESIGN", name.c_str(), 1);
	setenv("NODE", node.c_str(), 1);

	std::string cmd = "cat /home/projects/aspdac18/Results/"+name+"/"+node+"/abc_verilog.v | awk '{gsub(/\\\\.*\\//,\"\"); print}' > /home/projects/aspdac18/Results/"+name+"/"+node+"/abc_verilog_corr.v";
	system(cmd.c_str());

	cmd = "dc_shell-t -no_gui -64bit -output_log_file /home/projects/aspdac18/Results/"+name+"/"+node+"/dc_log -x \"source -echo -verbose ../scripts/dc_vts_abc.tcl \" ";
	system(cmd.c_str());
	costOnePatt = /*_getFICost(name) +*/ pList[maxSecIndex]->iIndex.size()*COMP_N;
}

void fault_c::doEco(std::string name){
	std::cout<<"############ ENTERING ECO CHECING ################" << std::endl;
	setenv("DESIGN", name.c_str(), 1);
	setenv("NODE", node.c_str(),2);

	std::string cmd = "lec_64 -nogui -ecogxl -dofile ../scripts/lec_eco.do";
	system(cmd.c_str());
	std::cout <<"VERIFYING THE FINAL VERILOG FILE WITH ORIGINAL VERILOG FILE"<<std::endl;
	cmd = "lec_64 -nogui -ecogxl -dofile ../scripts/lec_eco_verify.do";
        system(cmd.c_str());

}

bool fault_c::checkKeyConstraint(std::string name){
	int sec=0;
	std::vector<std::string> kcCheckList;
	setenv("DESIGN", name.c_str(), 1);
	
	std::string cmd = "dc_shell-t -no_gui -64bit -output_log_file /home/projects/aspdac18/Results/"+name+"/"+node+"/dc_key_constraints_log -x \"source -echo -verbose ../scripts/dc_key_constraints.tcl \" ";
	system(cmd.c_str());

    std::ifstream kc(("../../Results/"+name+"/"+node+"/key_constraints.do").c_str());
    std::ifstream kcValue(("../../Results/"+name+"/"+node+"/key_values.do").c_str());
 
	if(kc.fail()){
		std::cout << "key constraint file open failed!" << std::endl;
		exit(1);
	}
	if(kcValue.fail()){
		std::cout << "key constraint value file open failed!" << std::endl;
		exit(1);
	}
	std::vector<std::string> kcList, kcValueList;
	std::string line;
	while(getline(kc, line)){
		kcList.push_back(line);
	}	
	while(getline(kcValue, line)){
		kcValueList.push_back(line);
	}

    int cntZero=0, cntOne=0;
	for(int i=0; i<kcList.size(); i++){
		cmd = "rm ../../Results/"+name+"/"+node+"/new_key_contraint.do";
		system(cmd.c_str());
		std::ofstream nkc(("../../Results/"+name+"/"+node+"/new_key_constraint.do").c_str());
		for(int j=0; j<kcList.size(); j++){
			if(i!=j)
				nkc << kcList[j] << std::endl;	
		}
		cmd = "lec_64 -nogui -ecogxl -dofile ../scripts/lec_check_final_combo.do";
		system(cmd.c_str());

		if(!_checkEqKey(name)){
            if(kcValueList[i] == "0" && cntZero < TARGET_SEC/2 + KEY_BUFF){
                cntZero++;
                sec++;
                kcCheckList.push_back(kcList[i]);
            }
            else if(kcValueList[i] == "1" && cntOne < TARGET_SEC/2 + KEY_BUFF){
                cntOne++;
                sec++;
                kcCheckList.push_back(kcList[i]);
            }
			cmd = "rm ../../Results/"+name+"/"+node+"/lec_key_constraint_log";
			system(cmd.c_str());
			if (sec == TARGET_SEC) {
                std::cout<<"    TARGET SECURITY ACHIEVED        "<<std::endl;
                break;
            }
	
		}
	}
	numValidKey = sec;
	std::ofstream finalKC(("../../Results/"+name+"/"+node+"/key_constraints_final.do").c_str());
	if(finalKC.fail()){
		std::cout << "final key constraint file open failed!" << std::endl;
		exit(1);
	}
	if(sec == TARGET_SEC) {
		for(int i=0; i<kcCheckList.size(); i++){
			finalKC << kcCheckList[i] << std::endl;
		}
        return true;
	}
    else
        return false;
}

void fault_c::postProcesslockedVerilog(std::string name){
        std::cout <<"############# ENTERING LOCKED VERILOG ########### "<<std::endl;
        setenv("DESIGN", name.c_str(), 1);
        std::string cmd = "dc_shell-t -no_gui -64bit -output_log_file /home/projects/aspdac18/Results/"+name+"/final/locked_verilog.log -x \"source -echo -verbose ../scripts/locked_verilog.tcl \" ";
        system(cmd.c_str());
 	
}      

void fault_c::generateAPD(std::string name){
        std::cout <<"############# GENERATING APD ########### "<<std::endl;
        setenv("DESIGN", name.c_str(), 1);
        std::string cmd = "dc_shell-t -no_gui -64bit -output_log_file /home/projects/aspdac18/Results/"+name+"/final/apd_analysis.log -x \"source -echo -verbose ../scripts/generate_apd_fulllib.tcl \" ";
	system(cmd.c_str());
                        
}

bool fault_c::checkEqvOrigLock(std::string name){
    std::cout<<"############ ENTERING LEC EQUIVALENT CHECKING ################" << std::endl;
    setenv("DESIGN", name.c_str(), 1);
        
	std::string cmd = "lec_64 -nogui -ecogxl -dofile ../scripts/lec_equivalent_check.do";
    system(cmd.c_str());

	std::ifstream lec(("/home/projects/aspdac18/Results/"+name+"/final/lec_orig_report").c_str());
	std::string line;
	while(getline(lec, line)){
		if(line.find("Non-equivalent ") != std::string::npos)
			return false;
	}	

	return true;

}

void fault_c::removeNode(std::string name){
    std::string cmd = "rm -rf /home/projects/aspdac18/Results/"+name+"/"+node+"/";
    system(cmd.c_str());

}

double fault_c::_getFICost(std::string name){

	std::ifstream area(("/home/projects/aspdac18/Results/"+name+"/"+node+"/area.rpt").c_str());
	if(area.fail()){
                std::cerr<<"DC REPORT OPEN FAILED"<<std::endl;
                return 999999;
        }

	std::string line;
        std::vector<std::string> word;

        while(getline(area, line)){
                if(line.find("cell area:")!=std::string::npos){
                        boost::split(word, line, boost::is_any_of(":"));
                        return std::atof(word[1].c_str());
                }
        }
}

void fault_c::_compSec(){
	sec = 0;
	for(int i=0; i< pList.size(); i++){
		if(pList[i]->getSec() > sec)
			sec = pList[i]->getSec();
	}
}

void fault_c::_getLeastSec(){
	
	int /*SEC = 128,*/ min = 9999;
	for(int i=0; i< pList.size(); i++){
		if(pList[i]->getSec() >= TARGET_SEC && pList[i]->getSec() < min){
			min = pList[i]->getSec();
			minSecIndex = i;

		}
	}
}
void fault_c::_getMaxSec(){
        int max = -1;
	for(int i=0; i< pList.size(); i++){
                if(pList[i]->getSec() >= TARGET_SEC && pList[i]->getSec() > max){
                        max = pList[i]->getSec();
                        maxSecIndex = i;
                }
        }
}

void fault_c::_compOpFailList(){

	for(int i=0; i < opList.size(); i++){
		bool flag = false;
		std::vector<std::pair<int, char> > fList;
		for(int j=0; j< pList.size(); j++){
			if(pList[j]->findOpIndex(i)){
				flag =  true;
				fList.push_back(std::make_pair(j, pList[j]->opPatt[i]));
			}
		}

		if(flag){
			faultRes *fr = new faultRes(i, fList);
			fResList.push_back(fr);
		}
	}
}

bool fault_c::_checkEqKey(std::string name){

	std::ifstream kcLog(("../../Results/"+name+"/"+node+"/lec_key_constraint_log").c_str());	
	std::string line;

	while(getline(kcLog, line)){
		if(line.find("Non-eq") != std::string::npos)
			return false;
	}
	return true;
}
