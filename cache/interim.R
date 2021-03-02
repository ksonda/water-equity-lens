

d <- left_join(P1_tract,st_drop_geometry(P2_tract), by="GEOID")
d <- left_join(d,st_drop_geometry(P3_tract), by="GEOID")


## Make Pillar 1 Datasets
d <- d %>%
  mutate(
    P1_HBI = HBI_size_avg,
    P1_PPI = PPI,
    P1_Delinquency_rate = Delinquency_rate,
    P1_Cutoff_rate = Cutoff_Perc,
    P1_CAP = CAP_Percent,
    P1_Efficiency_Program = Incentive_rate,
    P1_Complaints_per_1000conn = complaint_per_conn,
    P1_Complaint_Resolution = complaint_addressed_percent,
    P1_Grade_HBI = Grade_HBI,
    P1_Grade_Affordability = Grade_AFF_avg,
    P1_Grade_Affordability_alt = Grade_AFF_alt,
    P1_Grade_Delinquency = Grade_delinquency,
    P1_Grade_Cutoff = Grade_cutoff,
    P1_Grade_CAP = Grade_CAP,
    P1_Grade_Efficiency = Grade_incentive,
    P1_Grade_Complaints_per1000conn = Grade_complaint_per_conn,
    P1_Grade_Complaint_Resolution = Grade_complaint_addressed_percent
  )

p1 <- select(d, GEOID, P1_HBI:P1_Grade_Complaint_Resolution)

## Make Pillar 2 Dataset 

d <- d %>% 
  mutate(
    P2_Staff_Share_Ratio = staff_share_ratio,
    P2_Grade_Staff_Share = Grade_staff_share_ratio
  )

p2 <- select(d, GEOID, P2_Staff_Share_Ratio,P2_Grade_Staff_Share)

## Make Pillar 3 Dataset

d <- d %>% mutate(
  P3_Meetings = meeting_count,
  P3_Grade_Meetings = Grade_meetings,
  P3_Breaks_100mi = breaks_100mi,
  P3_Grade_Breaks = Greade_breaks,
  P3_SSO_100mi = SSO_100mi,
  P3_Grade_SSO = Grade_SSO,
  P3_Lead_Lines_Percent = 100*prop_lead_lines,
  P3_Grade_Lead = Grade_prop_lead_lines,
  P3_Network_Renewal = network_renewal_percent,
  P3_Grade_Network_Renewal = Grade_nework_renewal_percent,
  P3_Maintenance_Hrs_100mi = Maintenance_100mi,
  P3_Grade_Maintenance = Grade_maintenance
)


p3 <- select(d,GEOID, P3_Meetings:P3_Grade_Maintenance)
             
             
tracts <- select(d,GEOID, P1_HBI:P3_Grade_Maintenance)


st_write(p1,"../out/Tracts_Pillar1.geojson")
write.csv(st_drop_geometry(p1),"../out/Tracts_Pillar1.csv")

st_write(p2,"../out/Tracts_Pillar2.geojson")
write.csv(st_drop_geometry(p2),"../out/Tracts_Pillar2.csv")

st_write(p3,"../out/Tracts_Pillar3.geojson")
write.csv(st_drop_geometry(p3),"../out/Tracts_Pillar3.csv")

st_write(tracts,"../out/Tracts_Pillars_All.geojson")
write.csv(st_drop_geometry(tracts),"../out/Tracts_Pillars_All.csv")

werwer
## Make Demographic Dataset