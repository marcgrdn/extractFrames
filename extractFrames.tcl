####### 					extractFrames.tcl 					#######
#######					       Author: Marc Gordon					#######
####### this script uses the output of StrAP's FrameLocator class to extract fames from the desired 	#######
####### trajectory, the extracted frames are then stored as a new trajectory for easier viewing		#######
#######													#######
####### Note: this script assumes the frame numbers line up with the trajectory - may not be true for	#######
####### GLYCAM extracts that rely on the added pdb frame - must be checked before running script	#######


set dcdOut "whole.dcd"
set dcdTmp "wholeTmp.dcd"

# open FrameLocator framelist for reading
set framelist [open "/home/marc/Desktop/tcltest/G12R_C_minEnergyPathFrames" r]

while {[gets $framelist line] >=0} {
		# read 2nd column
     		set value [lindex $line 1]
     		set frame frame_$value.dcd
     		
     		# ignore heading lines
     		if {$value eq "for"} {
			continue
		}
		
		# ignore blank lines
		if {$value eq""} {
			continue
		}
     		
     		
     		
     		# just a check for the first run through of the file - creates initial dcd file
		if {[file exists $dcdOut] == 1} {
			# copy whole.dcd to create separate input and output files for catdcd to run against
			file copy -- $dcdOut $dcdTmp
		} else {
			animate write dcd $dcdOut beg $value end $value waitfor all
			continue
		}	
		
		animate write dcd $frame beg $value end $value waitfor all
			
		# run catdcd to concatenate the files together
		exec /home/marc/Desktop/tcltest/catdcd -o $dcdOut -otype dcd wholeTmp.dcd $frame
		
		#remove temporary files wholeTmp.dcd and tmp.pdb
		file delete $dcdTmp
		file delete $frame
}

