-- select oornum, Dat , count(*)
-- from (
SELECT  
    cast(tot.[Dat] as date) as Dat
    ,[Jar]
    ,[Wek]
    ,[WekDag]
    ,tot.PrfCod
    ,tot.BehCod
    ,beh.BehNam
    ,[HrhNum]
    ,[Blk]
    ,cast([Hok] as int) as Hok
    ,[LevNum]
    ,cast([OorNum] as int) as OorNum
    , cast(tot.dienum as int) as AnimalServerId
    ,cast([BegDatPrf] as date ) as BegDatPrf
    ,cast([EndDatPrf] as date )  as EndDatPrf
    ,[LftDgn]
    ,[LacNum]
    ,cast([KlfDat] as date) as KlfDat
    ,[LacDgn]
    --   ,cast([InsDat] as date) as InsDat
    , (
        select max(matingdate) 
        from t_animal_matings 
        where tot.DieNum=animalserverid and matingdate<=tot.dat and matingdate>dateadd(mm, -9, tot.dat)
    ) as InsDat -- LETOP ! TODO:: Inseminatie moet altijd groter zijn dan de laatste calving
    ,cast([DrgZetDat] as date) as DrgZetDat
    ,cast([VrwKlfDat] as date) as VrwKlfDat
    ,cast([VlgKlfDat] as date) as VlgKlfDat
    
    ,[VrwDgn]
    ,[PrdSta]
    ,[SAC-1]
    ,HokoBrok1
    ,[SAC-2]
    ,HokoBrok2
    ,[SAC-3]
    ,HokoBrok3
    ,[SAC-4]
    ,HokoBrok4
    ,[C21-9]
    ,[C21-10]
    ,gea.cfc as GeaBrok --  TODO DIUT MOETEN WE NOGUITZOEKEN
    ,[DelPro-13]

    ,[OpnRV] as OpnRvDsHans -- in de calpis dataset staat de nieuwere water moet er nog uit
    

    ,rv1.name as 'rv1.name'


    ,rv1.opnProd as 'rv1.Prod'
    ,rv1.opnIncWater  as 'rv1.OpnIncWater'
    ,rv1.opnMinWater as 'rv1.OpnMinWater'
    ,rv1.dsPct  as 'rv1.dsPct'
    ,rv1.ricBez  as 'rv1.ricBez'    
    ,rv1.trbatches  as 'rv1.trBatches'    

    ,rv2.name as 'rv2.name'
    ,rv2.opnProd as 'rv2.Prod'
    ,rv2.opnIncWater  as 'rv2.OpnIncWater'
    ,rv2.opnMinWater as 'rv2.OpnMinWater'
    ,rv2.dsPct  as 'rv2.dsPct'   
    ,rv2.ricBez  as 'rv2.ricBez'    
    ,rv2.trbatches  as 'rv2.trBatches'    
  
    ,rv3.name as 'rv3.name'
    ,rv3.opnProd as 'rv3.Prod'
    ,rv3.opnIncWater  as 'rv3.OpnIncWater'
    ,rv3.opnMinWater as 'rv3.OpnMinWater'
    ,rv3.dsPct  as 'rv3.dsPct'    
    ,rv3.ricBez  as 'rv3.ricBez'   
    ,rv3.trbatches  as 'rv3.trBatches'    

    ,rv4.name as 'rv4.name'
    ,rv4.opnProd as 'rv4.Prod'
    ,rv4.opnIncWater  as 'rv4.OpnIncWater'
    ,rv4.opnMinWater as 'rv4.OpnMinWater'
    ,rv4.dsPct  as 'rv4.dsPct'    
    ,rv4.ricBez  as 'rv4.ricBez'   
    ,rv4.trbatches  as 'rv4.trBatches'    

    -- ,opnDsVR
    -- ,opnDsCD

    ,[GewO]
    ,[GewA]

    ,tot.[AntMlkO]
    ,tot.[KgMlkO]
    ,tot.[AntMlkA]
    ,tot.[KgMlkA]

    ,gea.[AntMlkO] as AntMlkOGea
    ,gea.[KgMlkO]  as KgMlkOGea
    ,gea.[AntMlkA] as AntMlkAGea
    ,gea.[KgMlkA]  as KgtMlkAGea
    ,[MlkStd]
    ,[VetStd]
    ,[EiwStd]
    ,[LacStd]
    ,[KetStd]
    ,[UreStd]
    ,[CelStd]


    --- weekly AO results
    
    , mpr_dag.Fat_Concentration as 'mpr_dag.Fat_Concentration'
    , mpr_dag.Protein_Concentration as 'mpr_dag.Protein_Concentration'
    , mpr_dag.Lactose_Concentration as 'mpr_dag.Lactose_Concentration'
    , mpr_dag.SCC as 'mpr_dag.SCC'
    , mpr_dag.Urea_Concentration as 'mpr_dag.Urea_Concentration' 

    , mpr_week.Fat_Concentration as 'mpr_week.Fat_Concentration'
    , mpr_week.Protein_Concentration as 'mpr_week.Protein_Concentration'
    , mpr_week.Lactose_Concentration as 'mpr_week.Lactose_Concentration'
    , mpr_week.SCC as 'mpr_week.SCC'
    , mpr_week.Urea_Concentration as 'mpr_week.Urea_Concentration '
    
  
-- into #bert
from 
    Tvl_Dier_Datum_Totaal as tot
left join 
    T_Proef_Behandeling as beh on tot.behcod=beh.BehCod and tot.prfcod=beh.prfcod

left join 
    T_RAW_crv_melkdata as mpr_dag  on mpr_dag.AnimalServerId=tot.dienum and tot.dat=cast(mpr_dag.milking_begin_datetime as date)
left join 
    TVL_Dier_Datum_Crv as mpr_week on datepart(wk, mpr_week.date) = wek and year(mpr_week.date) = jar and mpr_week.animalserverid=tot.dienum
left join (
    select 
        cast(imdat as date) as imdat,
        cow, 
        sum(iif(datepart(hh, imdat) < 12, imwt * 0.01,0)) as kgmlko,
        sum(iif(datepart(hh, imdat) > 12, imwt * 0.01,0)) as kgmlka,
        sum(iif(datepart(hh, imdat) < 12, 1,0)) as antmlko,
        sum(iif(datepart(hh, imdat) > 12, 1,0)) as antmlka,        
        sum(imwt) as kgmlketm, 
        sum(cast(cfc as real)) as cfc

    FROM 
        T_RAW_gea_milk 
    group by 
        cast(imdat as date) ,  cow
) as gea on gea.cow=tot.oornum and gea.imdat = tot.dat
left join (
    select distinct 
        cast(k0 as date) as [date], 
        cast(k2 as int) as cow, 
        cast(k11 as real) as HokoRV,
        cast(k52 as real) as HokoBrok1,
        cast(k61 as real) as HokoBrok2,
        cast(k70 as real) as HokoBrok3, 
        cast(k79 as real) as HokoBrok4 
    from   
        (SELECT DISTINCT K0, k2, K11, k52, K61, K70, k79 FROM bert_hokofarmcd ) AS bert_hokofarmcd
    
) as hokofarm  on hokofarm.cow=tot.oornum and hokofarm.date = tot.dat
left join (
    -- deze moet nog nagekkeken worden, het enige nadeel wat ik kan verzinnen is dat een groupname wijziging halverwege de dag niet handig uitpakt
      select 
        cast(k0 as date) as [date], 
        cast(k2 as int) as cow, 
        K10 as name, 
        -- raw_trioliet.groupname ,
        cast(k11 as real) as opnProd,
        cast(k11 as real) as opnIncWater,  
        
        -- sum(cast(k11*(1-waterPct) as real)) as opnMinWater,
        (sum(totaalgeladen)-sum(waterkg))/sum(totaalgeladen) * k11 as opnMinWater,

        
        count(distinct filename) as trBatches, 
        count(distinct vr.datetime) as ricBez,
        sum(dsKg)/sum(prodKg) as dsPct,
        sum(dsKg)/sum(prodKg)* ((cast(sum(totaalgeladen) as real) -cast(sum(waterkg)as real)) / cast(sum(totaalgeladen) as real) * sum(intake))  as opnDsVR

    from (
        select 
            cast(k0 as date) as k0, cast(k2 as int) as k2,  cast(k11 as float)  as k11 , k10 
        from 
            BERT_HOKOFARMCD 
        where 
            cast(k11 as float) >0
    ) as BERT_HOKOFARMCD
    
    LEFT JOIN  
        raw_hokofarmvr as vr  ON  K2=vr.COW AND k0=CAST(VR.DATE AS DATE) and k10=vr.feedType
    
    LEFT JOIN (
        select distinct  
            cast(date as date) as date, subgroupnr, groupname , filename 
        from  raw_trioliet 
    )  as raw_trioliet on station=subgroupnr and raw_trioliet.date=cast(vr.date as date) AND  raw_trioliet.groupname  = k10
    
    left join vl_fedde_trioliet_ds as ds on cast(ds.date as date)=cast(vr.date as date)  and ds.groupname=raw_trioliet.groupname 
    group by  k0, k2,k10, k11


) as rv1 on 
     rv1.date=hokofarm.date  and rv1.cow=hokofarm.cow 
left join (

    -- deze moet nog nagekkeken worden, het enige nadeel wat ik kan verzinnen is dat een groupname wijziging halverwege de dag niet handig uitpakt
      select 
        cast(k0 as date) as [date], 
        cast(k2 as int) as cow, 
        k20 as name, 
        -- raw_trioliet.groupname ,
        cast(k21 as real) as opnProd,
        cast(k21 as real) as opnIncWater,  
        
        -- sum(cast(k21*(1-waterPct) as real)) as opnMinWater,
        (sum(totaalgeladen)-sum(waterkg))/sum(totaalgeladen) * k21 as opnMinWater,        
        
        count(distinct filename) as trBatches, 
        count(distinct vr.datetime) as ricBez,
        sum(dsKg)/sum(prodKg) as dsPct,
        sum(dsKg)/sum(prodKg)* ((cast(sum(totaalgeladen) as real) -cast(sum(waterkg)as real)) / cast(sum(totaalgeladen) as real) * sum(intake))  as opnDsVR

    from (
        select 
            cast(k0 as date) as k0, cast(k2 as int) as k2,  cast(k21 as float)  as k21 , k20 
        from 
            BERT_HOKOFARMCD 
        where 
            cast(k21 as float) >0
    ) as BERT_HOKOFARMCD
    
    LEFT JOIN  
        raw_hokofarmvr as vr  ON  K2=vr.COW AND k0=CAST(VR.DATE AS DATE) and k20=vr.feedType
    
    LEFT JOIN (
        select distinct  
            cast(date as date) as date, subgroupnr, groupname , filename 
        from  raw_trioliet 
    )  as raw_trioliet on station=subgroupnr and raw_trioliet.date=cast(vr.date as date) AND  raw_trioliet.groupname  = k20
    
    left join vl_fedde_trioliet_ds as ds on cast(ds.date as date)=cast(vr.date as date)  and ds.groupname=raw_trioliet.groupname 
    group by  k0, k2,k20, k21
   


) as rv2 on  rv2.date=tot.dat and rv2.cow=tot.oornum
left join (

    -- deze moet nog nagekkeken worden, het enige nadeel wat ik kan verzinnen is dat een groupname wijziging halverwege de dag niet handig uitpakt
    select 
        cast(k0 as date) as [date], 
        cast(k2 as int) as cow, 
        k30 as name, 
        -- raw_trioliet.groupname ,
        cast(k31 as real) as opnProd,
        cast(k31 as real) as opnIncWater,  
        
        -- sum(cast(k31*(1-waterPct) as real)) as opnMinWater,
        (sum(totaalgeladen)-sum(waterkg))/sum(totaalgeladen) * k31 as opnMinWater,
        count(distinct filename) as trBatches, 
        count(distinct vr.datetime) as ricBez,
        sum(dsKg)/sum(prodKg) as dsPct,
        sum(dsKg)/sum(prodKg)* ((cast(sum(totaalgeladen) as real) -cast(sum(waterkg)as real)) / cast(sum(totaalgeladen) as real) * sum(intake))  as opnDsVR

    from (
        select 
            cast(k0 as date) as k0, cast(k2 as int) as k2,  cast(k31 as float)  as k31 , k30 
        from 
            BERT_HOKOFARMCD 
        where 
            cast(k31 as float) >0
    ) as BERT_HOKOFARMCD
    
    LEFT JOIN  
        raw_hokofarmvr as vr  ON  K2=vr.COW AND k0=CAST(VR.DATE AS DATE) and k30=vr.feedType
    
    LEFT JOIN (
        select distinct  
            cast(date as date) as date, subgroupnr, groupname , filename 
        from  raw_trioliet 
    )  as raw_trioliet on station=subgroupnr and raw_trioliet.date=cast(vr.date as date) AND  raw_trioliet.groupname  = k30
    
    left join vl_fedde_trioliet_ds as ds on cast(ds.date as date)=cast(vr.date as date)  and ds.groupname=raw_trioliet.groupname 
    group by  k0, k2,k30, k31



) as rv3 on  rv3.date=tot.dat and rv3.cow=tot.oornum
left join (

    -- deze moet nog nagekkeken worden, het enige nadeel wat ik kan verzinnen is dat een groupname wijziging halverwege de dag niet handig uitpakt
       select 
        cast(k0 as date) as [date], 
        cast(k2 as int) as cow, 
        k40 as name, 
        -- raw_trioliet.groupname ,
        cast(k41 as real) as opnProd,
        cast(k41 as real) as opnIncWater,  
        
        -- sum(cast(k41*(1-waterPct) as real)) as opnMinWater,
        (sum(totaalgeladen)-sum(waterkg))/sum(totaalgeladen) * k41 as opnMinWater,
        
        count(distinct filename)    as trBatches, 
        count(distinct vr.datetime) as ricBez,
        sum(dsKg)/sum(prodKg)       as dsPct,
        sum(dsKg)/sum(prodKg)* ((cast(sum(totaalgeladen) as real) -cast(sum(waterkg)as real)) / cast(sum(totaalgeladen) as real) * sum(intake))  as opnDsVR

    from (
        select 
            cast(k0 as date) as k0, cast(k2 as int) as k2,  cast(k41 as float)  as k41 , k40 
        from 
            BERT_HOKOFARMCD 
        where 
            cast(k41 as float) >0
    ) as BERT_HOKOFARMCD
    
    LEFT JOIN  
        raw_hokofarmvr as vr  ON  K2=vr.COW AND k0=CAST(VR.DATE AS DATE) and k40=vr.feedType
    
    LEFT JOIN (
        select distinct  
            cast(date as date) as date, subgroupnr, groupname , filename 
        from  raw_trioliet 
    )  as raw_trioliet on station=subgroupnr and raw_trioliet.date=cast(vr.date as date) AND  raw_trioliet.groupname  = k40
    
    left join vl_fedde_trioliet_ds as ds on cast(ds.date as date)=cast(vr.date as date)  and ds.groupname=raw_trioliet.groupname 
    group by  k0, k2,k40, k41

) as rv4 on  rv4.date=tot.dat and rv4.cow=tot.oornum
where 
    tot.prfcod='4400003055'
    -- and oornum = 1211
    -- and dat='2020-07-14'
order by dat, behcod, oornum

