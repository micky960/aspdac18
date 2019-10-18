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

int main () {
	std::ifstream lec("/home/projects/aspdac18/Results/CSAW_b20_C/final/lec_report");
        std::string line;
        while(getline(lec, line)){
                if(line.find("Non-equivalent       1") != std::string::npos)
                        std::cout<<"Non-Equivalence found!"<<std::endl;
        }


}
