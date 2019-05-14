void DEMONComm()
{
	struct timeval start,end;
    	gettimeofday(&start,NULL);

	systemCall("python " + config["DEMON_Dir"] + "launch.py "+config["DATA_DIR"]+config["INSTANCE_NAME"]);
	systemCall("mv DEMON.gen "+config["RESULT_DIR"]);

	gettimeofday(&end,NULL);

	double span = end.tv_sec-start.tv_sec + (end.tv_usec - start.tv_usec)/1000000.0;
    	ofstream otime;
    	otime.open((config["RESULT_DIR"]+"Total_Time.txt").c_str(), ios::out|ios::app);
    	otime <<"DEMON"<<"\t"<<span<<endl;
    	otime.close();
	
	systemCall("rm ./Demon_time.txt");
}

void CFinderComm()
{
	systemCall("rm -r "+config["TMP_DIR"]); 
	struct timeval start,end;
    	gettimeofday(&start,NULL);
	
  	systemCall(config["CFinder_Dir"] + "CFinder_commandline64 -i "+config["DATA_DIR"]+config["INSTANCE_NAME"]+ " -l "+config["CFinder_Dir"]+"licence.txt -o "+config["TMP_DIR"]+" -k "+config["CFinder_k"]);

	gettimeofday(&end,NULL);
	double span = end.tv_sec-start.tv_sec + (end.tv_usec - start.tv_usec)/1000000.0;
    	ofstream otime;
    	otime.open((config["RESULT_DIR"]+"Total_Time.txt").c_str(), ios::out|ios::app);
    	otime <<"CFinder"<<"\t"<<span<<endl;
    	otime.close();
	systemCall(config["CFinder_Dir"] + "CFtrans "+config["TMP_DIR"]+"k="+config["CFinder_k"]+"/communities "+config["RESULT_DIR"]+"CFinder.gen");
	
	systemCall("if [ ! -d " + config["TMP_DIR"]+" ]; then\n mkdir "+config["TMP_DIR"]+"\n fi");
}

void NISEComm()
{
	struct timeval start,end;
    	gettimeofday(&start,NULL);
	systemCall("cp "+config["DATA_DIR"]+config["INSTANCE_NAME"]+ " "+config["TMP_DIR"]);
	string NISEGraphFile=config["TMP_DIR"]+config["INSTANCE_NAME"];
  	systemCall("matlab -nodesktop -nosplash -r \"addpath('"+config["NISE_Dir"]+"');addpath('"+config["NISE_Dir"]+"matlab_bgl');addpath('"+config["NISE_Dir"]+"GraclusSeeds/graclus1.2/matlab');"+"NISERun('"+NISEGraphFile+"','"+config["NISE_seeds"]+"',"+config["NISE_k"]+");exit\"");
	systemCall("cd ../..");
	gettimeofday(&end,NULL);
	double span = end.tv_sec-start.tv_sec + (end.tv_usec - start.tv_usec)/1000000.0;
    	ofstream otime;
    	otime.open((config["RESULT_DIR"]+"Total_Time.txt").c_str(), ios::out|ios::app);
    	otime <<"NISE"<<"\t"<<span<<endl;
    	otime.close();
	systemCall("mv NISE.gen "+config["RESULT_DIR"]+"NISE.gen");
}


void BigClamComm()
{
	struct timeval start,end;
    	gettimeofday(&start,NULL);
	systemCall("cp "+config["DATA_DIR"]+config["INSTANCE_NAME"]+ " "+config["TMP_DIR"]);
	string GraphFile=config["TMP_DIR"]+config["INSTANCE_NAME"];
	systemCall(config["BigClam_Dir"] + "dataTran " + config["TMP_DIR"]+config["INSTANCE_NAME"] + " " + config["TMP_DIR"]+"graph.txt");
	
  	systemCall(config["BigClam_Dir"] + "bigclam" + " -i:" + config["TMP_DIR"]+"graph.txt" + " -o:" + config["RESULT_DIR"] + "BigClam.gen "+ "-c:"+config["BigClam_c"] + " -mc:"+config["BigClam_min_c"] + " -xc:"+config["BigClam_max_c"] + " -nc:"+config["BigClam_nc"] + " -nt:"+config["BigClam_nt"] + " -sa:"+config["BigClam_sa"] + " -sb:"+config["BigClam_sb"]  + " | tee " + config["RESULT_DIR"] + "BigClam.log");
  	
  	systemCall("mv " + config["RESULT_DIR"] + "BigClam.gencmtyvv.txt " + config["RESULT_DIR"] + "BigClam.gen");
  	systemCall("mv " + config["RESULT_DIR"] + "BigClam.gengraph.gexf " + config["RESULT_DIR"] + "BigClam.gexf");
	
	gettimeofday(&end,NULL);
	double span = end.tv_sec-start.tv_sec + (end.tv_usec - start.tv_usec)/1000000.0;
    	ofstream otime;
    	otime.open((config["RESULT_DIR"]+"Total_Time.txt").c_str(), ios::out|ios::app);
    	otime <<"BigClam"<<"\t"<<span<<endl;
    	otime.close();
}
