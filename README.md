# SMOKE-MOVES-Input-QA-Tool
This repository contains the SMOKE-MOVES Input QA Tool I built for the Lake Michigan Air Directors Consortium over 9 months 
as a remote access transportation and air quality analyst intern.  The project was my first experience with coding and solidified my interest in infrastructure planning.

Air quality modeling is a multi-step process that requires emissions to be modeled from pollutant sources and then processed 
to produce compatible inputs for air quality models (AQM). The EPA uses the Motor Vehicle Emission Simulator (MOVES) to 
estimate onroad vehicle emissions of criteria pollutants, greenhouse gases, and air toxics (except for California sources, 
which are produced with a California specific model).  The MOVES emissions estimates are included as the onroad vehicle 
portion of the National Emissions Inventory (NEI).  The NEI is then processed with the EPA’s Sparse Matrix Operator Kernel 
(SMOKE) Modeling System which is designed to account for the impact of temporal allocation, spatial allocation, growth, 
chemical speciation and control factors on emissions.  This process is commonly referred to as the SMOKE-MOVES methodology
and is relied upon to produce compatible emissions input data for many U.S. EPA AQMs including CMAQ, CAMx, REMSAD, and AERMOD.

Inputs for the MOVES model are comprised of 2GB of mySQL databases containing county-level information on the following:

•	Vehicle Miles Traveled (VMT) mix by vehicle type

•	VMT distribution by road type

•	Speed

•	Age distribution by vehicle type

•	Long-haul truck “hoteling” hours

•	Other information

Previous analyses have identified significant anomalies in the reported data used as MOVES inputs.  Additionally, data is not 
received for about half of U.S. counties and MOVES default values are applied.  

LADCO has identified MOVES input data improvement as having great potential in improving EPA emissions modeling.  To better 
understand the MOVES-SMOKE input database and the impact of anomalies and default values on emission estimates, I spent 9 months 
working remotely to build the LADCO SMOKE-MOVES Import QA Tool.  The project was built around smaller reports contracted 
previously with Environ, ERG, and others.  The tool uses a series of R scripts with embedded SQL queries to compile the entire 
SMOKE-MOVES vehicle fleet input database in R dataframes.  The tool then uses ggplot2 to produce ~70,000 QA graphics/reports portraying input data trends at the county, state, regional, and national level.  The requested QA reports, and additional relevant 
transportation trends that I identified, are stored as graphics in a directory constructed by the tool on the user’s local 
machine.  The tool is designed to be versatile enough that any user can run it and store the QA reports on their machine with 
each new iteration of the SMOKE-MOVES input database.

Please message me with questions.
