function code_out=prntable(numsats,samples_per_ms,GPS)
SVtaps1=[3 10];           %Taps of G1 to feedback into LFSR
SVtaps2=[2 3 6 8 9 10];   %Taps of G2 to feedback into LFSR

SVouts1=10;        %Output TAPS from G1 <FIXED>


SVoutsGPS = ...
[2,6;
 3,7;
 4,8;
 5,9;
 1,9;
 2,10;
 1,8;
 2,9;
 3,10;
 2,3;
 3,4;
 5,6;
 6,7;
 7,8;
 8,9;
 9,10;
 1,4;
 2,5;
 3,6;
 4,7;
 5,8;
 6,9;
 1,3;
 4,6;
 5,7;
 6,8;
 7,9;
 8,10;
 1,6;
 2,7;
 3,8;
 4,9;
];

    G1_IRNSS= ...
    [1 1 1 0 1 0 0 1 1 1;
     0 0 0 0 1 0 0 1 1 0;
     1 0 0 0 1 1 0 1 0 0;
     0 1 0 1 1 1 0 0 1 0;
     1 1 1 0 1 1 0 0 0 0;
     0 0 0 1 1 0 1 0 1 1;
     0 0 0 0 0 1 0 1 0 0 ];
     G2_IRNSS= ...
    [0 0 1 1 1 0 1 1 1 1;
     0 1 0 1 1 1 1 1 0 1;
     1 0 0 0 1 1 0 0 0 1;
     0 0 1 0 1 0 1 0 1 1;
     1 0 1 0 0 1 0 0 0 1;
     0 1 0 0 1 0 1 1 0 0;
     0 0 1 0 0 0 1 1 1 0 ];
if(GPS)
    G1_init= repmat(ones(1,10),numsats,1);
    G2_init= repmat(ones(1,10),numsats,1);
else
    G1_init= G1_IRNSS(1:numsats,:);
    G2_init= G2_IRNSS(1:numsats,:);
end
if(GPS)
    SVouts2=SVoutsGPS(1:numsats,:);
else
    SVouts2=repmat(10,numsats,1);
end
code_length=1023;
code_out=goldcode(code_length,numsats,samples_per_ms,SVtaps1,SVtaps2,SVouts1,SVouts2,G1_init,G2_init);



end

