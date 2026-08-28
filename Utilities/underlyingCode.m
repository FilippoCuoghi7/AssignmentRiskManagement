function u = underlyingCode(underlyingName)
% Translates underlyingName

%% Underlyings
if strcmp(underlyingName, 'Eurostoxx')
     u = 'SX5E';     
 elseif strcmp(underlyingName, 'AirLiquide')
     u = 'AI FP';
 elseif strcmp(underlyingName, 'Allianz')
     u = 'ALV GY';
 elseif strcmp(underlyingName, 'InBev')
     u = 'ABI BB';
 elseif strcmp(underlyingName, 'Arcelor')
     u = 'MT NA';
 elseif strcmp(underlyingName, 'ASML')
     u = 'ASML NA';
elseif strcmp(underlyingName, 'Generali')
    u = 'G IM';
elseif strcmp(underlyingName, 'AXA')
    u = 'CS FP';
elseif strcmp(underlyingName, 'BBVA')
    u = 'BBVA SQ';
elseif strcmp(underlyingName, 'Santander')
    u = 'SAN SQ';
elseif strcmp(underlyingName, 'BASF')
    u = 'BAS GY';
elseif strcmp(underlyingName, 'Bayer')
    u = 'BAYN GY';
elseif strcmp(underlyingName, 'BMW')
    u = 'BMW GY';
elseif strcmp(underlyingName, 'BNP')
    u = 'BNP FP';
elseif strcmp(underlyingName, 'Carrefour')
    u = 'CA FP';
elseif strcmp(underlyingName, 'StGobain')
    u = 'SGO FP';
elseif strcmp(underlyingName, 'CRH')
    u = 'CRH ID';
elseif strcmp(underlyingName, 'Daimler')
    u = 'DAI GY';
elseif strcmp(underlyingName, 'Danone')
    u = 'BN FP';
elseif strcmp(underlyingName, 'DB')
    u = 'DBK GY';
elseif strcmp(underlyingName, 'DT')
    u = 'DTE GY';
elseif strcmp(underlyingName, 'EON')
    u = 'EOAN GY';
elseif strcmp(underlyingName, 'ENEL')
    u = 'ENEL IM';
elseif strcmp(underlyingName, 'ENI')
    u = 'ENI IM';
elseif strcmp(underlyingName, 'Essilor')
    u = 'EI FP';
elseif strcmp(underlyingName, 'FT')
    u = 'FTE FP';
elseif strcmp(underlyingName, 'GdF')
    u = 'GDF FP';
elseif strcmp(underlyingName, 'Iberdrola')
    u = 'IBE SQ';
elseif strcmp(underlyingName, 'Inditex')
    u = 'ITX SQ';
elseif strcmp(underlyingName, 'ING')
    u = 'INGA NA';
elseif strcmp(underlyingName, 'ISP')
    u = 'ISP IM';
elseif strcmp(underlyingName, 'Philips')
    u = 'PHIA NA';
elseif strcmp(underlyingName, 'Oreal')
    u = 'OR FP';
elseif strcmp(underlyingName, 'LVMH')
    u = 'MC FP';
elseif strcmp(underlyingName, 'MunichRe')
    u = 'MUV2 GY';
elseif strcmp(underlyingName, 'Nokia')
    u = 'NOK1V FH';
elseif strcmp(underlyingName, 'Repsol')
    u = 'REP SQ';
elseif strcmp(underlyingName, 'RWE')
    u = 'RWE GY';
elseif strcmp(underlyingName, 'Sanofi')
    u = 'SAN FP';
elseif strcmp(underlyingName, 'SAP')
    u = 'SAP GY';
elseif strcmp(underlyingName, 'Schneider')
    u = 'SU FP';
elseif strcmp(underlyingName, 'Siemens')
    u = 'SIE GY';
elseif strcmp(underlyingName, 'SocGen')
    u = 'GLE FP';
elseif strcmp(underlyingName, 'Telefonica')
    u = 'TEF SQ';
elseif strcmp(underlyingName, 'Total')
    u = 'FP FP';
elseif strcmp(underlyingName, 'Unibail')
    u = 'UL FP';
elseif strcmp(underlyingName, 'Unicredit')
    u = 'UCG IM';
elseif strcmp(underlyingName, 'Unilever')
    u = 'UNA NA';
elseif strcmp(underlyingName, 'Vinci')
    u = 'DG FP';
elseif strcmp(underlyingName, 'Vivendi')
    u = 'VIV FP';
elseif strcmp(underlyingName, 'Volkswagen')
    u = 'VOW3 GY';
end

end % underlyingCode