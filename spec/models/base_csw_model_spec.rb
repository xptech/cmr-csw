require 'spec_helper'

RSpec.describe BaseCswModel do
  describe 'Adding CWIC keywords' do
    it 'is possible to mark a single collection as CWIC-enabled' do
      response_xml = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<results>
    <hits>1</hits>
    <took>48</took>
    <result concept-id="C1000000247-DEMO_PROV" revision-id="6" format="application/iso19115+xml">
        <gmi:MI_Metadata
            xmlns:gmi="http://www.isotc211.org/2005/gmi"

            xmlns:gco="http://www.isotc211.org/2005/gco"

            xmlns:gmd="http://www.isotc211.org/2005/gmd"

            xmlns:gmx="http://www.isotc211.org/2005/gmx"

            xmlns:gsr="http://www.isotc211.org/2005/gsr"

            xmlns:gss="http://www.isotc211.org/2005/gss"

            xmlns:gts="http://www.isotc211.org/2005/gts"

            xmlns:srv="http://www.isotc211.org/2005/srv"

            xmlns:gml="http://www.opengis.net/gml/3.2"

            xmlns:xlink="http://www.w3.org/1999/xlink"

            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

            xmlns:swe="http://schemas.opengis.net/sweCommon/2.0/"

            xmlns:eos="http://earthdata.nasa.gov/schema/eos"

            xmlns:xs="http://www.w3.org/2001/XMLSchema">
            <!--Other Properties, all:0, coi:0,ii:0,si:0,pli:0,pri:0,qi:0,gi:0,ci:0,dk:0,pcc:0,icc:0,scc:0-->
            <gmd:fileIdentifier>
                <gco:CharacterString>gov.nasa.echo:A minimal valid collection V 1</gco:CharacterString>
            </gmd:fileIdentifier>
            <gmd:language>
                <gco:CharacterString>eng</gco:CharacterString>
            </gmd:language>
            <gmd:characterSet>
                <gmd:MD_CharacterSetCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"
                               codeListValue="utf8">utf8</gmd:MD_CharacterSetCode>
            </gmd:characterSet>
            <gmd:hierarchyLevel>
                <gmd:MD_ScopeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_ScopeCode"
                        codeListValue="series">series</gmd:MD_ScopeCode>
            </gmd:hierarchyLevel>
            <gmd:contact>
                <gmd:CI_ResponsibleParty>
                    <gmd:organisationName>
                        <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                    </gmd:organisationName>
                    <gmd:role>
                        <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                             codeListValue="pointOfContact">pointOfContact</gmd:CI_RoleCode>
                    </gmd:role>
                </gmd:CI_ResponsibleParty>
            </gmd:contact>
            <gmd:dateStamp>
                <gco:DateTime>2016-05-27T09:47:19.983-04:00</gco:DateTime>
            </gmd:dateStamp>
            <gmd:metadataStandardName>
                <gco:CharacterString>ISO 19115-2 Geographic Information - Metadata Part 2 Extensions for imagery and gridded data</gco:CharacterString>
            </gmd:metadataStandardName>
            <gmd:metadataStandardVersion>
                <gco:CharacterString>ISO 19115-2:2009(E)</gco:CharacterString>
            </gmd:metadataStandardVersion>
            <gmd:identificationInfo>
                <gmd:MD_DataIdentification>
                    <gmd:citation>
                        <gmd:CI_Citation>
                            <gmd:title>
                                <gco:CharacterString>MINIMAL &gt; A minimal valid collection</gco:CharacterString>
                            </gmd:title>
                            <gmd:date>
                                <gmd:CI_Date>
                                    <gmd:date>
                                        <gco:DateTime>1999-12-31T19:00:00-05:00</gco:DateTime>
                                    </gmd:date>
                                    <gmd:dateType>
                                        <gmd:CI_DateTypeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                                             codeListValue="revision">revision</gmd:CI_DateTypeCode>
                                    </gmd:dateType>
                                </gmd:CI_Date>
                            </gmd:date>
                            <gmd:date>
                                <gmd:CI_Date>
                                    <gmd:date>
                                        <gco:DateTime>1999-12-31T19:00:00-05:00</gco:DateTime>
                                    </gmd:date>
                                    <gmd:dateType>
                                        <gmd:CI_DateTypeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                                             codeListValue="creation">creation</gmd:CI_DateTypeCode>
                                    </gmd:dateType>
                                </gmd:CI_Date>
                            </gmd:date>
                            <gmd:edition>
                                <gco:CharacterString>1</gco:CharacterString>
                            </gmd:edition>
                            <gmd:identifier>
                                <gmd:MD_Identifier>
                                    <gmd:code>
                                        <gco:CharacterString>MINIMAL</gco:CharacterString>
                                    </gmd:code>
                                    <gmd:description>
                                        <gco:CharacterString>A minimal valid collection</gco:CharacterString>
                                    </gmd:description>
                                </gmd:MD_Identifier>
                            </gmd:identifier>
                            <gmd:otherCitationDetails>
                                <gco:CharacterString/>
                            </gmd:otherCitationDetails>
                        </gmd:CI_Citation>
                    </gmd:citation>
                    <gmd:abstract>
                        <gco:CharacterString>A minimal valid collection</gco:CharacterString>
                    </gmd:abstract>
                    <gmd:purpose gco:nilReason="missing"/>
                    <gmd:pointOfContact>
                        <gmd:CI_ResponsibleParty>
                            <gmd:organisationName>
                                <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                            </gmd:organisationName>
                            <gmd:role>
                                <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                   codeListValue="pointOfContact">pointOfContact</gmd:CI_RoleCode>
                            </gmd:role>
                        </gmd:CI_ResponsibleParty>
                    </gmd:pointOfContact>
                    <gmd:descriptiveKeywords>
                        <gmd:MD_Keywords>
                            <gmd:keyword>
                                <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                            </gmd:keyword>
                            <gmd:type>
                                <gmd:MD_KeywordTypeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode"
                                          codeListValue="dataCenter">dataCenter</gmd:MD_KeywordTypeCode>
                            </gmd:type>
                            <gmd:thesaurusName>
                                <gmd:CI_Citation>
                                    <gmd:title>
                                        <gco:CharacterString> NASA/Global Change Master Directory (GCMD) Data Center Keywords </gco:CharacterString>
                                    </gmd:title>
                                    <gmd:date>
                                        <gmd:CI_Date>
                                            <gmd:date>
                                                <gco:Date>2008-02-07</gco:Date>
                                            </gmd:date>
                                            <gmd:dateType>
                                                <gmd:CI_DateTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                                                   codeListValue="publication">publication</gmd:CI_DateTypeCode>
                                            </gmd:dateType>
                                        </gmd:CI_Date>
                                    </gmd:date>
                                    <gmd:identifier/>
                                    <gmd:citedResponsibleParty>
                                        <gmd:CI_ResponsibleParty>
                                            <gmd:organisationName>
                                                <gco:CharacterString>NASA</gco:CharacterString>
                                            </gmd:organisationName>
                                            <gmd:positionName>
                                                <gco:CharacterString>GCMD User Support Office</gco:CharacterString>
                                            </gmd:positionName>
                                            <gmd:contactInfo>
                                                <gmd:CI_Contact>
                                                    <gmd:address>
                                                        <gmd:CI_Address>
                                                            <gmd:electronicMailAddress>
                                                                <gco:CharacterString>gcmduso@gcmd.gsfc.nasa.gov</gco:CharacterString>
                                                            </gmd:electronicMailAddress>
                                                        </gmd:CI_Address>
                                                    </gmd:address>
                                                    <gmd:onlineResource>
                                                        <gmd:CI_OnlineResource>
                                                            <gmd:linkage>
                                                                <gmd:URL>http://gcmd.nasa.gov/MailComments/MailComments.jsf?rcpt=gcmduso</gmd:URL>
                                                            </gmd:linkage>
                                                            <gmd:name>
                                                                <gco:CharacterString>GCMD Feedback Form</gco:CharacterString>
                                                            </gmd:name>
                                                            <gmd:description>
                                                                <gco:CharacterString>Have a Comment for the GCMD?</gco:CharacterString>
                                                            </gmd:description>
                                                            <gmd:function>
                                                                <gmd:CI_OnLineFunctionCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                                                                     codeListValue="information">information</gmd:CI_OnLineFunctionCode>
                                                            </gmd:function>
                                                        </gmd:CI_OnlineResource>
                                                    </gmd:onlineResource>
                                                </gmd:CI_Contact>
                                            </gmd:contactInfo>
                                            <gmd:role>
                                                <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                               codeListValue="custodian">custodian</gmd:CI_RoleCode>
                                            </gmd:role>
                                        </gmd:CI_ResponsibleParty>
                                    </gmd:citedResponsibleParty>
                                    <gmd:citedResponsibleParty>
                                        <gmd:CI_ResponsibleParty>
                                            <gmd:organisationName gco:nilReason="inapplicable"/>
                                            <gmd:contactInfo>
                                                <gmd:CI_Contact>
                                                    <gmd:onlineResource xlink:title="GCMD Keyword Page">
                                                        <gmd:CI_OnlineResource>
                                                            <gmd:linkage>
                                                                <gmd:URL>http://gcmd.nasa.gov/Resources/valids/</gmd:URL>
                                                            </gmd:linkage>
                                                            <gmd:name>
                                                                <gco:CharacterString>GCMD Keywords Page</gco:CharacterString>
                                                            </gmd:name>
                                                            <gmd:description>
                                                                <gco:CharacterString>This page describes the NASA GCMD Keywords, how to reference those keywords and provides download instructions. </gco:CharacterString>
                                                            </gmd:description>
                                                            <gmd:function>
                                                                <gmd:CI_OnLineFunctionCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                                                                     codeListValue="information">information</gmd:CI_OnLineFunctionCode>
                                                            </gmd:function>
                                                        </gmd:CI_OnlineResource>
                                                    </gmd:onlineResource>
                                                </gmd:CI_Contact>
                                            </gmd:contactInfo>
                                            <gmd:role>
                                                <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                               codeListValue="custodian">custodian</gmd:CI_RoleCode>
                                            </gmd:role>
                                        </gmd:CI_ResponsibleParty>
                                    </gmd:citedResponsibleParty>
                                </gmd:CI_Citation>
                            </gmd:thesaurusName>
                        </gmd:MD_Keywords>
                    </gmd:descriptiveKeywords>
                    <gmd:resourceConstraints>
                        <gmd:MD_LegalConstraints>
                            <gmd:useLimitation>
                                <gco:CharacterString>Restriction Comment:</gco:CharacterString>
                            </gmd:useLimitation>
                            <gmd:otherConstraints>
                                <gco:CharacterString>Restriction Flag:</gco:CharacterString>
                            </gmd:otherConstraints>
                        </gmd:MD_LegalConstraints>
                    </gmd:resourceConstraints>
                    <gmd:language>
                        <gco:CharacterString>eng</gco:CharacterString>
                    </gmd:language>
                    <gmd:characterSet>
                        <gmd:MD_CharacterSetCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"
                                     codeListValue="utf8">utf8</gmd:MD_CharacterSetCode>
                    </gmd:characterSet>
                    <gmd:extent>
                        <gmd:EX_Extent id="boundingExtent">
                            <gmd:description gco:nilReason="unknown"/>
                        </gmd:EX_Extent>
                    </gmd:extent>
                    <gmd:supplementalInformation/>
                    <gmd:processingLevel>
                        <gmd:MD_Identifier>
                            <gmd:code>
                                <gco:CharacterString/>
                            </gmd:code>
                            <gmd:description>
                                <gco:CharacterString/>
                            </gmd:description>
                        </gmd:MD_Identifier>
                    </gmd:processingLevel>
                </gmd:MD_DataIdentification>
            </gmd:identificationInfo>
            <gmd:distributionInfo>
                <gmd:MD_Distribution>
                    <gmd:distributor>
                        <gmd:MD_Distributor>
                            <gmd:distributorContact>
                                <gmd:CI_ResponsibleParty>
                                    <gmd:organisationName>
                                        <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                                    </gmd:organisationName>
                                    <gmd:role>
                                        <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                         codeListValue="distributor">distributor</gmd:CI_RoleCode>
                                    </gmd:role>
                                </gmd:CI_ResponsibleParty>
                            </gmd:distributorContact>
                            <gmd:distributionOrderProcess>
                                <gmd:MD_StandardOrderProcess>
                                    <gmd:fees gco:nilReason="missing"/>
                                </gmd:MD_StandardOrderProcess>
                            </gmd:distributionOrderProcess>
                            <gmd:distributorTransferOptions>
                                <gmd:MD_DigitalTransferOptions/>
                            </gmd:distributorTransferOptions>
                        </gmd:MD_Distributor>
                    </gmd:distributor>
                </gmd:MD_Distribution>
            </gmd:distributionInfo>
            <gmd:dataQualityInfo>
                <gmd:DQ_DataQuality>
                    <gmd:scope>
                        <gmd:DQ_Scope>
                            <gmd:level>
                                <gmd:MD_ScopeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_ScopeCode"
                                    codeListValue="series">series</gmd:MD_ScopeCode>
                            </gmd:level>
                        </gmd:DQ_Scope>
                    </gmd:scope>
                    <gmd:lineage>
                        <gmd:LI_Lineage>
                            <gmd:processStep>
                                <gmi:LE_ProcessStep>
                                    <gmd:description gco:nilReason="unknown"/>
                                </gmi:LE_ProcessStep>
                            </gmd:processStep>
                        </gmd:LI_Lineage>
                    </gmd:lineage>
                </gmd:DQ_DataQuality>
            </gmd:dataQualityInfo>
            <gmd:metadataMaintenance>
                <gmd:MD_MaintenanceInformation>
                    <gmd:maintenanceAndUpdateFrequency>
                        <gmd:MD_MaintenanceFrequencyCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_MaintenanceFrequencyCode"
                                             codeListValue="irregular">irregular</gmd:MD_MaintenanceFrequencyCode>
                    </gmd:maintenanceAndUpdateFrequency>
                    <gmd:maintenanceNote>
                        <gco:CharacterString>Translated from ECHO using ECHOToISO.xsl Version: 1.32 (Dec. 9, 2015)</gco:CharacterString>
                    </gmd:maintenanceNote>
                </gmd:MD_MaintenanceInformation>
            </gmd:metadataMaintenance>
            <gmi:acquisitionInformation>
                <gmi:MI_AcquisitionInformation/>
            </gmi:acquisitionInformation>
        </gmi:MI_Metadata>
        <tags>
            <tag>
                <tagKey>org.ceos.wgiss.cwic.granules.prod</tagKey>
            </tag>
        </tags>
    </result>
</results>
      eos
      document = Nokogiri::XML(response_xml)
      new_doc = BaseCswModel.add_cwic_keywords document
      expect(new_doc.root.xpath('/results/result/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()="CWIC > CEOS WGISS Integrated Catalog"', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco')).to eq(true)
    end
  end
  it 'is possible to mark a single collection as not CWIC-enabled when a different tag exists' do
    response_xml = <<-eos
    <?xml version="1.0" encoding="UTF-8"?>
    <results>
        <hits>1</hits>
        <took>48</took>
        <result concept-id="C1000000247-DEMO_PROV" revision-id="6" format="application/iso19115+xml">
            <gmi:MI_Metadata
                xmlns:gmi="http://www.isotc211.org/2005/gmi"

                xmlns:gco="http://www.isotc211.org/2005/gco"

                xmlns:gmd="http://www.isotc211.org/2005/gmd"

                xmlns:gmx="http://www.isotc211.org/2005/gmx"

                xmlns:gsr="http://www.isotc211.org/2005/gsr"

                xmlns:gss="http://www.isotc211.org/2005/gss"

                xmlns:gts="http://www.isotc211.org/2005/gts"

                xmlns:srv="http://www.isotc211.org/2005/srv"

                xmlns:gml="http://www.opengis.net/gml/3.2"

                xmlns:xlink="http://www.w3.org/1999/xlink"

                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

                xmlns:swe="http://schemas.opengis.net/sweCommon/2.0/"

                xmlns:eos="http://earthdata.nasa.gov/schema/eos"

                xmlns:xs="http://www.w3.org/2001/XMLSchema">
                <!--Other Properties, all:0, coi:0,ii:0,si:0,pli:0,pri:0,qi:0,gi:0,ci:0,dk:0,pcc:0,icc:0,scc:0-->
                <gmd:fileIdentifier>
                    <gco:CharacterString>gov.nasa.echo:A minimal valid collection V 1</gco:CharacterString>
                </gmd:fileIdentifier>
                <gmd:language>
                    <gco:CharacterString>eng</gco:CharacterString>
                </gmd:language>
                <gmd:characterSet>
                    <gmd:MD_CharacterSetCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"
                                   codeListValue="utf8">utf8</gmd:MD_CharacterSetCode>
                </gmd:characterSet>
                <gmd:hierarchyLevel>
                    <gmd:MD_ScopeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_ScopeCode"
                            codeListValue="series">series</gmd:MD_ScopeCode>
                </gmd:hierarchyLevel>
                <gmd:contact>
                    <gmd:CI_ResponsibleParty>
                        <gmd:organisationName>
                            <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                        </gmd:organisationName>
                        <gmd:role>
                            <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                 codeListValue="pointOfContact">pointOfContact</gmd:CI_RoleCode>
                        </gmd:role>
                    </gmd:CI_ResponsibleParty>
                </gmd:contact>
                <gmd:dateStamp>
                    <gco:DateTime>2016-05-27T09:47:19.983-04:00</gco:DateTime>
                </gmd:dateStamp>
                <gmd:metadataStandardName>
                    <gco:CharacterString>ISO 19115-2 Geographic Information - Metadata Part 2 Extensions for imagery and gridded data</gco:CharacterString>
                </gmd:metadataStandardName>
                <gmd:metadataStandardVersion>
                    <gco:CharacterString>ISO 19115-2:2009(E)</gco:CharacterString>
                </gmd:metadataStandardVersion>
                <gmd:identificationInfo>
                    <gmd:MD_DataIdentification>
                        <gmd:citation>
                            <gmd:CI_Citation>
                                <gmd:title>
                                    <gco:CharacterString>MINIMAL &gt; A minimal valid collection</gco:CharacterString>
                                </gmd:title>
                                <gmd:date>
                                    <gmd:CI_Date>
                                        <gmd:date>
                                            <gco:DateTime>1999-12-31T19:00:00-05:00</gco:DateTime>
                                        </gmd:date>
                                        <gmd:dateType>
                                            <gmd:CI_DateTypeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                                                 codeListValue="revision">revision</gmd:CI_DateTypeCode>
                                        </gmd:dateType>
                                    </gmd:CI_Date>
                                </gmd:date>
                                <gmd:date>
                                    <gmd:CI_Date>
                                        <gmd:date>
                                            <gco:DateTime>1999-12-31T19:00:00-05:00</gco:DateTime>
                                        </gmd:date>
                                        <gmd:dateType>
                                            <gmd:CI_DateTypeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                                                 codeListValue="creation">creation</gmd:CI_DateTypeCode>
                                        </gmd:dateType>
                                    </gmd:CI_Date>
                                </gmd:date>
                                <gmd:edition>
                                    <gco:CharacterString>1</gco:CharacterString>
                                </gmd:edition>
                                <gmd:identifier>
                                    <gmd:MD_Identifier>
                                        <gmd:code>
                                            <gco:CharacterString>MINIMAL</gco:CharacterString>
                                        </gmd:code>
                                        <gmd:description>
                                            <gco:CharacterString>A minimal valid collection</gco:CharacterString>
                                        </gmd:description>
                                    </gmd:MD_Identifier>
                                </gmd:identifier>
                                <gmd:otherCitationDetails>
                                    <gco:CharacterString/>
                                </gmd:otherCitationDetails>
                            </gmd:CI_Citation>
                        </gmd:citation>
                        <gmd:abstract>
                            <gco:CharacterString>A minimal valid collection</gco:CharacterString>
                        </gmd:abstract>
                        <gmd:purpose gco:nilReason="missing"/>
                        <gmd:pointOfContact>
                            <gmd:CI_ResponsibleParty>
                                <gmd:organisationName>
                                    <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                                </gmd:organisationName>
                                <gmd:role>
                                    <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                       codeListValue="pointOfContact">pointOfContact</gmd:CI_RoleCode>
                                </gmd:role>
                            </gmd:CI_ResponsibleParty>
                        </gmd:pointOfContact>
                        <gmd:descriptiveKeywords>
                            <gmd:MD_Keywords>
                                <gmd:keyword>
                                    <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                                </gmd:keyword>
                                <gmd:type>
                                    <gmd:MD_KeywordTypeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode"
                                              codeListValue="dataCenter">dataCenter</gmd:MD_KeywordTypeCode>
                                </gmd:type>
                                <gmd:thesaurusName>
                                    <gmd:CI_Citation>
                                        <gmd:title>
                                            <gco:CharacterString> NASA/Global Change Master Directory (GCMD) Data Center Keywords </gco:CharacterString>
                                        </gmd:title>
                                        <gmd:date>
                                            <gmd:CI_Date>
                                                <gmd:date>
                                                    <gco:Date>2008-02-07</gco:Date>
                                                </gmd:date>
                                                <gmd:dateType>
                                                    <gmd:CI_DateTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                                                       codeListValue="publication">publication</gmd:CI_DateTypeCode>
                                                </gmd:dateType>
                                            </gmd:CI_Date>
                                        </gmd:date>
                                        <gmd:identifier/>
                                        <gmd:citedResponsibleParty>
                                            <gmd:CI_ResponsibleParty>
                                                <gmd:organisationName>
                                                    <gco:CharacterString>NASA</gco:CharacterString>
                                                </gmd:organisationName>
                                                <gmd:positionName>
                                                    <gco:CharacterString>GCMD User Support Office</gco:CharacterString>
                                                </gmd:positionName>
                                                <gmd:contactInfo>
                                                    <gmd:CI_Contact>
                                                        <gmd:address>
                                                            <gmd:CI_Address>
                                                                <gmd:electronicMailAddress>
                                                                    <gco:CharacterString>gcmduso@gcmd.gsfc.nasa.gov</gco:CharacterString>
                                                                </gmd:electronicMailAddress>
                                                            </gmd:CI_Address>
                                                        </gmd:address>
                                                        <gmd:onlineResource>
                                                            <gmd:CI_OnlineResource>
                                                                <gmd:linkage>
                                                                    <gmd:URL>http://gcmd.nasa.gov/MailComments/MailComments.jsf?rcpt=gcmduso</gmd:URL>
                                                                </gmd:linkage>
                                                                <gmd:name>
                                                                    <gco:CharacterString>GCMD Feedback Form</gco:CharacterString>
                                                                </gmd:name>
                                                                <gmd:description>
                                                                    <gco:CharacterString>Have a Comment for the GCMD?</gco:CharacterString>
                                                                </gmd:description>
                                                                <gmd:function>
                                                                    <gmd:CI_OnLineFunctionCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                                                                         codeListValue="information">information</gmd:CI_OnLineFunctionCode>
                                                                </gmd:function>
                                                            </gmd:CI_OnlineResource>
                                                        </gmd:onlineResource>
                                                    </gmd:CI_Contact>
                                                </gmd:contactInfo>
                                                <gmd:role>
                                                    <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                                   codeListValue="custodian">custodian</gmd:CI_RoleCode>
                                                </gmd:role>
                                            </gmd:CI_ResponsibleParty>
                                        </gmd:citedResponsibleParty>
                                        <gmd:citedResponsibleParty>
                                            <gmd:CI_ResponsibleParty>
                                                <gmd:organisationName gco:nilReason="inapplicable"/>
                                                <gmd:contactInfo>
                                                    <gmd:CI_Contact>
                                                        <gmd:onlineResource xlink:title="GCMD Keyword Page">
                                                            <gmd:CI_OnlineResource>
                                                                <gmd:linkage>
                                                                    <gmd:URL>http://gcmd.nasa.gov/Resources/valids/</gmd:URL>
                                                                </gmd:linkage>
                                                                <gmd:name>
                                                                    <gco:CharacterString>GCMD Keywords Page</gco:CharacterString>
                                                                </gmd:name>
                                                                <gmd:description>
                                                                    <gco:CharacterString>This page describes the NASA GCMD Keywords, how to reference those keywords and provides download instructions. </gco:CharacterString>
                                                                </gmd:description>
                                                                <gmd:function>
                                                                    <gmd:CI_OnLineFunctionCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                                                                         codeListValue="information">information</gmd:CI_OnLineFunctionCode>
                                                                </gmd:function>
                                                            </gmd:CI_OnlineResource>
                                                        </gmd:onlineResource>
                                                    </gmd:CI_Contact>
                                                </gmd:contactInfo>
                                                <gmd:role>
                                                    <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                                   codeListValue="custodian">custodian</gmd:CI_RoleCode>
                                                </gmd:role>
                                            </gmd:CI_ResponsibleParty>
                                        </gmd:citedResponsibleParty>
                                    </gmd:CI_Citation>
                                </gmd:thesaurusName>
                            </gmd:MD_Keywords>
                        </gmd:descriptiveKeywords>
                        <gmd:resourceConstraints>
                            <gmd:MD_LegalConstraints>
                                <gmd:useLimitation>
                                    <gco:CharacterString>Restriction Comment:</gco:CharacterString>
                                </gmd:useLimitation>
                                <gmd:otherConstraints>
                                    <gco:CharacterString>Restriction Flag:</gco:CharacterString>
                                </gmd:otherConstraints>
                            </gmd:MD_LegalConstraints>
                        </gmd:resourceConstraints>
                        <gmd:language>
                            <gco:CharacterString>eng</gco:CharacterString>
                        </gmd:language>
                        <gmd:characterSet>
                            <gmd:MD_CharacterSetCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"
                                         codeListValue="utf8">utf8</gmd:MD_CharacterSetCode>
                        </gmd:characterSet>
                        <gmd:extent>
                            <gmd:EX_Extent id="boundingExtent">
                                <gmd:description gco:nilReason="unknown"/>
                            </gmd:EX_Extent>
                        </gmd:extent>
                        <gmd:supplementalInformation/>
                        <gmd:processingLevel>
                            <gmd:MD_Identifier>
                                <gmd:code>
                                    <gco:CharacterString/>
                                </gmd:code>
                                <gmd:description>
                                    <gco:CharacterString/>
                                </gmd:description>
                            </gmd:MD_Identifier>
                        </gmd:processingLevel>
                    </gmd:MD_DataIdentification>
                </gmd:identificationInfo>
                <gmd:distributionInfo>
                    <gmd:MD_Distribution>
                        <gmd:distributor>
                            <gmd:MD_Distributor>
                                <gmd:distributorContact>
                                    <gmd:CI_ResponsibleParty>
                                        <gmd:organisationName>
                                            <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                                        </gmd:organisationName>
                                        <gmd:role>
                                            <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                             codeListValue="distributor">distributor</gmd:CI_RoleCode>
                                        </gmd:role>
                                    </gmd:CI_ResponsibleParty>
                                </gmd:distributorContact>
                                <gmd:distributionOrderProcess>
                                    <gmd:MD_StandardOrderProcess>
                                        <gmd:fees gco:nilReason="missing"/>
                                    </gmd:MD_StandardOrderProcess>
                                </gmd:distributionOrderProcess>
                                <gmd:distributorTransferOptions>
                                    <gmd:MD_DigitalTransferOptions/>
                                </gmd:distributorTransferOptions>
                            </gmd:MD_Distributor>
                        </gmd:distributor>
                    </gmd:MD_Distribution>
                </gmd:distributionInfo>
                <gmd:dataQualityInfo>
                    <gmd:DQ_DataQuality>
                        <gmd:scope>
                            <gmd:DQ_Scope>
                                <gmd:level>
                                    <gmd:MD_ScopeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_ScopeCode"
                                        codeListValue="series">series</gmd:MD_ScopeCode>
                                </gmd:level>
                            </gmd:DQ_Scope>
                        </gmd:scope>
                        <gmd:lineage>
                            <gmd:LI_Lineage>
                                <gmd:processStep>
                                    <gmi:LE_ProcessStep>
                                        <gmd:description gco:nilReason="unknown"/>
                                    </gmi:LE_ProcessStep>
                                </gmd:processStep>
                            </gmd:LI_Lineage>
                        </gmd:lineage>
                    </gmd:DQ_DataQuality>
                </gmd:dataQualityInfo>
                <gmd:metadataMaintenance>
                    <gmd:MD_MaintenanceInformation>
                        <gmd:maintenanceAndUpdateFrequency>
                            <gmd:MD_MaintenanceFrequencyCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_MaintenanceFrequencyCode"
                                                 codeListValue="irregular">irregular</gmd:MD_MaintenanceFrequencyCode>
                        </gmd:maintenanceAndUpdateFrequency>
                        <gmd:maintenanceNote>
                            <gco:CharacterString>Translated from ECHO using ECHOToISO.xsl Version: 1.32 (Dec. 9, 2015)</gco:CharacterString>
                        </gmd:maintenanceNote>
                    </gmd:MD_MaintenanceInformation>
                </gmd:metadataMaintenance>
                <gmi:acquisitionInformation>
                    <gmi:MI_AcquisitionInformation/>
                </gmi:acquisitionInformation>
            </gmi:MI_Metadata>
            <tags>
                <tag>
                    <tagKey>foo.bar</tagKey>
                </tag>
            </tags>
        </result>
    </results>
    eos
    document = Nokogiri::XML(response_xml)
    new_doc = BaseCswModel.add_cwic_keywords document
    expect(new_doc.root.xpath('/results/result/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()="CWIC > CEOS WGISS Integrated Catalog"', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco')).to eq(false)
  end
  it 'is possible to mark a single collection as not CWIC-enabled when no tags exist' do
    response_xml = <<-eos
          <?xml version="1.0" encoding="UTF-8"?>
          <results>
              <hits>1</hits>
              <took>48</took>
              <result concept-id="C1000000247-DEMO_PROV" revision-id="6" format="application/iso19115+xml">
                  <gmi:MI_Metadata
                      xmlns:gmi="http://www.isotc211.org/2005/gmi"

                      xmlns:gco="http://www.isotc211.org/2005/gco"

                      xmlns:gmd="http://www.isotc211.org/2005/gmd"

                      xmlns:gmx="http://www.isotc211.org/2005/gmx"

                      xmlns:gsr="http://www.isotc211.org/2005/gsr"

                      xmlns:gss="http://www.isotc211.org/2005/gss"

                      xmlns:gts="http://www.isotc211.org/2005/gts"

                      xmlns:srv="http://www.isotc211.org/2005/srv"

                      xmlns:gml="http://www.opengis.net/gml/3.2"

                      xmlns:xlink="http://www.w3.org/1999/xlink"

                      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

                      xmlns:swe="http://schemas.opengis.net/sweCommon/2.0/"

                      xmlns:eos="http://earthdata.nasa.gov/schema/eos"

                      xmlns:xs="http://www.w3.org/2001/XMLSchema">
                      <!--Other Properties, all:0, coi:0,ii:0,si:0,pli:0,pri:0,qi:0,gi:0,ci:0,dk:0,pcc:0,icc:0,scc:0-->
                      <gmd:fileIdentifier>
                          <gco:CharacterString>gov.nasa.echo:A minimal valid collection V 1</gco:CharacterString>
                      </gmd:fileIdentifier>
                      <gmd:language>
                          <gco:CharacterString>eng</gco:CharacterString>
                      </gmd:language>
                      <gmd:characterSet>
                          <gmd:MD_CharacterSetCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"
                                         codeListValue="utf8">utf8</gmd:MD_CharacterSetCode>
                      </gmd:characterSet>
                      <gmd:hierarchyLevel>
                          <gmd:MD_ScopeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_ScopeCode"
                                  codeListValue="series">series</gmd:MD_ScopeCode>
                      </gmd:hierarchyLevel>
                      <gmd:contact>
                          <gmd:CI_ResponsibleParty>
                              <gmd:organisationName>
                                  <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                              </gmd:organisationName>
                              <gmd:role>
                                  <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                       codeListValue="pointOfContact">pointOfContact</gmd:CI_RoleCode>
                              </gmd:role>
                          </gmd:CI_ResponsibleParty>
                      </gmd:contact>
                      <gmd:dateStamp>
                          <gco:DateTime>2016-05-27T09:47:19.983-04:00</gco:DateTime>
                      </gmd:dateStamp>
                      <gmd:metadataStandardName>
                          <gco:CharacterString>ISO 19115-2 Geographic Information - Metadata Part 2 Extensions for imagery and gridded data</gco:CharacterString>
                      </gmd:metadataStandardName>
                      <gmd:metadataStandardVersion>
                          <gco:CharacterString>ISO 19115-2:2009(E)</gco:CharacterString>
                      </gmd:metadataStandardVersion>
                      <gmd:identificationInfo>
                          <gmd:MD_DataIdentification>
                              <gmd:citation>
                                  <gmd:CI_Citation>
                                      <gmd:title>
                                          <gco:CharacterString>MINIMAL &gt; A minimal valid collection</gco:CharacterString>
                                      </gmd:title>
                                      <gmd:date>
                                          <gmd:CI_Date>
                                              <gmd:date>
                                                  <gco:DateTime>1999-12-31T19:00:00-05:00</gco:DateTime>
                                              </gmd:date>
                                              <gmd:dateType>
                                                  <gmd:CI_DateTypeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                                                       codeListValue="revision">revision</gmd:CI_DateTypeCode>
                                              </gmd:dateType>
                                          </gmd:CI_Date>
                                      </gmd:date>
                                      <gmd:date>
                                          <gmd:CI_Date>
                                              <gmd:date>
                                                  <gco:DateTime>1999-12-31T19:00:00-05:00</gco:DateTime>
                                              </gmd:date>
                                              <gmd:dateType>
                                                  <gmd:CI_DateTypeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                                                       codeListValue="creation">creation</gmd:CI_DateTypeCode>
                                              </gmd:dateType>
                                          </gmd:CI_Date>
                                      </gmd:date>
                                      <gmd:edition>
                                          <gco:CharacterString>1</gco:CharacterString>
                                      </gmd:edition>
                                      <gmd:identifier>
                                          <gmd:MD_Identifier>
                                              <gmd:code>
                                                  <gco:CharacterString>MINIMAL</gco:CharacterString>
                                              </gmd:code>
                                              <gmd:description>
                                                  <gco:CharacterString>A minimal valid collection</gco:CharacterString>
                                              </gmd:description>
                                          </gmd:MD_Identifier>
                                      </gmd:identifier>
                                      <gmd:otherCitationDetails>
                                          <gco:CharacterString/>
                                      </gmd:otherCitationDetails>
                                  </gmd:CI_Citation>
                              </gmd:citation>
                              <gmd:abstract>
                                  <gco:CharacterString>A minimal valid collection</gco:CharacterString>
                              </gmd:abstract>
                              <gmd:purpose gco:nilReason="missing"/>
                              <gmd:pointOfContact>
                                  <gmd:CI_ResponsibleParty>
                                      <gmd:organisationName>
                                          <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                                      </gmd:organisationName>
                                      <gmd:role>
                                          <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                             codeListValue="pointOfContact">pointOfContact</gmd:CI_RoleCode>
                                      </gmd:role>
                                  </gmd:CI_ResponsibleParty>
                              </gmd:pointOfContact>
                              <gmd:descriptiveKeywords>
                                  <gmd:MD_Keywords>
                                      <gmd:keyword>
                                          <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                                      </gmd:keyword>
                                      <gmd:type>
                                          <gmd:MD_KeywordTypeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode"
                                                    codeListValue="dataCenter">dataCenter</gmd:MD_KeywordTypeCode>
                                      </gmd:type>
                                      <gmd:thesaurusName>
                                          <gmd:CI_Citation>
                                              <gmd:title>
                                                  <gco:CharacterString> NASA/Global Change Master Directory (GCMD) Data Center Keywords </gco:CharacterString>
                                              </gmd:title>
                                              <gmd:date>
                                                  <gmd:CI_Date>
                                                      <gmd:date>
                                                          <gco:Date>2008-02-07</gco:Date>
                                                      </gmd:date>
                                                      <gmd:dateType>
                                                          <gmd:CI_DateTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode"
                                                             codeListValue="publication">publication</gmd:CI_DateTypeCode>
                                                      </gmd:dateType>
                                                  </gmd:CI_Date>
                                              </gmd:date>
                                              <gmd:identifier/>
                                              <gmd:citedResponsibleParty>
                                                  <gmd:CI_ResponsibleParty>
                                                      <gmd:organisationName>
                                                          <gco:CharacterString>NASA</gco:CharacterString>
                                                      </gmd:organisationName>
                                                      <gmd:positionName>
                                                          <gco:CharacterString>GCMD User Support Office</gco:CharacterString>
                                                      </gmd:positionName>
                                                      <gmd:contactInfo>
                                                          <gmd:CI_Contact>
                                                              <gmd:address>
                                                                  <gmd:CI_Address>
                                                                      <gmd:electronicMailAddress>
                                                                          <gco:CharacterString>gcmduso@gcmd.gsfc.nasa.gov</gco:CharacterString>
                                                                      </gmd:electronicMailAddress>
                                                                  </gmd:CI_Address>
                                                              </gmd:address>
                                                              <gmd:onlineResource>
                                                                  <gmd:CI_OnlineResource>
                                                                      <gmd:linkage>
                                                                          <gmd:URL>http://gcmd.nasa.gov/MailComments/MailComments.jsf?rcpt=gcmduso</gmd:URL>
                                                                      </gmd:linkage>
                                                                      <gmd:name>
                                                                          <gco:CharacterString>GCMD Feedback Form</gco:CharacterString>
                                                                      </gmd:name>
                                                                      <gmd:description>
                                                                          <gco:CharacterString>Have a Comment for the GCMD?</gco:CharacterString>
                                                                      </gmd:description>
                                                                      <gmd:function>
                                                                          <gmd:CI_OnLineFunctionCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                                                                               codeListValue="information">information</gmd:CI_OnLineFunctionCode>
                                                                      </gmd:function>
                                                                  </gmd:CI_OnlineResource>
                                                              </gmd:onlineResource>
                                                          </gmd:CI_Contact>
                                                      </gmd:contactInfo>
                                                      <gmd:role>
                                                          <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                                         codeListValue="custodian">custodian</gmd:CI_RoleCode>
                                                      </gmd:role>
                                                  </gmd:CI_ResponsibleParty>
                                              </gmd:citedResponsibleParty>
                                              <gmd:citedResponsibleParty>
                                                  <gmd:CI_ResponsibleParty>
                                                      <gmd:organisationName gco:nilReason="inapplicable"/>
                                                      <gmd:contactInfo>
                                                          <gmd:CI_Contact>
                                                              <gmd:onlineResource xlink:title="GCMD Keyword Page">
                                                                  <gmd:CI_OnlineResource>
                                                                      <gmd:linkage>
                                                                          <gmd:URL>http://gcmd.nasa.gov/Resources/valids/</gmd:URL>
                                                                      </gmd:linkage>
                                                                      <gmd:name>
                                                                          <gco:CharacterString>GCMD Keywords Page</gco:CharacterString>
                                                                      </gmd:name>
                                                                      <gmd:description>
                                                                          <gco:CharacterString>This page describes the NASA GCMD Keywords, how to reference those keywords and provides download instructions. </gco:CharacterString>
                                                                      </gmd:description>
                                                                      <gmd:function>
                                                                          <gmd:CI_OnLineFunctionCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_OnLineFunctionCode"
                                                                               codeListValue="information">information</gmd:CI_OnLineFunctionCode>
                                                                      </gmd:function>
                                                                  </gmd:CI_OnlineResource>
                                                              </gmd:onlineResource>
                                                          </gmd:CI_Contact>
                                                      </gmd:contactInfo>
                                                      <gmd:role>
                                                          <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                                         codeListValue="custodian">custodian</gmd:CI_RoleCode>
                                                      </gmd:role>
                                                  </gmd:CI_ResponsibleParty>
                                              </gmd:citedResponsibleParty>
                                          </gmd:CI_Citation>
                                      </gmd:thesaurusName>
                                  </gmd:MD_Keywords>
                              </gmd:descriptiveKeywords>
                              <gmd:resourceConstraints>
                                  <gmd:MD_LegalConstraints>
                                      <gmd:useLimitation>
                                          <gco:CharacterString>Restriction Comment:</gco:CharacterString>
                                      </gmd:useLimitation>
                                      <gmd:otherConstraints>
                                          <gco:CharacterString>Restriction Flag:</gco:CharacterString>
                                      </gmd:otherConstraints>
                                  </gmd:MD_LegalConstraints>
                              </gmd:resourceConstraints>
                              <gmd:language>
                                  <gco:CharacterString>eng</gco:CharacterString>
                              </gmd:language>
                              <gmd:characterSet>
                                  <gmd:MD_CharacterSetCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_CharacterSetCode"
                                               codeListValue="utf8">utf8</gmd:MD_CharacterSetCode>
                              </gmd:characterSet>
                              <gmd:extent>
                                  <gmd:EX_Extent id="boundingExtent">
                                      <gmd:description gco:nilReason="unknown"/>
                                  </gmd:EX_Extent>
                              </gmd:extent>
                              <gmd:supplementalInformation/>
                              <gmd:processingLevel>
                                  <gmd:MD_Identifier>
                                      <gmd:code>
                                          <gco:CharacterString/>
                                      </gmd:code>
                                      <gmd:description>
                                          <gco:CharacterString/>
                                      </gmd:description>
                                  </gmd:MD_Identifier>
                              </gmd:processingLevel>
                          </gmd:MD_DataIdentification>
                      </gmd:identificationInfo>
                      <gmd:distributionInfo>
                          <gmd:MD_Distribution>
                              <gmd:distributor>
                                  <gmd:MD_Distributor>
                                      <gmd:distributorContact>
                                          <gmd:CI_ResponsibleParty>
                                              <gmd:organisationName>
                                                  <gco:CharacterString>Iu5mwLBVOgcpkOHWEq3Vc6omMNxp0I5cpkqSLnprMWfmn9AmbD0DgP3WBgOEusYuby3QOMHu9Lgx9kW99gTZjOrZjT4hCwFMJS6RMLxEbesrJjIyTo7PNBfUralJYYS2Qxz7Sj46FrxEvbrrPVcCvPtLLYnrvGQ4n1hIgZX37k3Z2FArErZl6r2E7EvF1Fzbn6VrqlRc9DqCicixGMA5NhuF3yEWqsNj9lozKTDg1Nb2u13C</gco:CharacterString>
                                              </gmd:organisationName>
                                              <gmd:role>
                                                  <gmd:CI_RoleCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#CI_RoleCode"
                                                   codeListValue="distributor">distributor</gmd:CI_RoleCode>
                                              </gmd:role>
                                          </gmd:CI_ResponsibleParty>
                                      </gmd:distributorContact>
                                      <gmd:distributionOrderProcess>
                                          <gmd:MD_StandardOrderProcess>
                                              <gmd:fees gco:nilReason="missing"/>
                                          </gmd:MD_StandardOrderProcess>
                                      </gmd:distributionOrderProcess>
                                      <gmd:distributorTransferOptions>
                                          <gmd:MD_DigitalTransferOptions/>
                                      </gmd:distributorTransferOptions>
                                  </gmd:MD_Distributor>
                              </gmd:distributor>
                          </gmd:MD_Distribution>
                      </gmd:distributionInfo>
                      <gmd:dataQualityInfo>
                          <gmd:DQ_DataQuality>
                              <gmd:scope>
                                  <gmd:DQ_Scope>
                                      <gmd:level>
                                          <gmd:MD_ScopeCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_ScopeCode"
                                              codeListValue="series">series</gmd:MD_ScopeCode>
                                      </gmd:level>
                                  </gmd:DQ_Scope>
                              </gmd:scope>
                              <gmd:lineage>
                                  <gmd:LI_Lineage>
                                      <gmd:processStep>
                                          <gmi:LE_ProcessStep>
                                              <gmd:description gco:nilReason="unknown"/>
                                          </gmi:LE_ProcessStep>
                                      </gmd:processStep>
                                  </gmd:LI_Lineage>
                              </gmd:lineage>
                          </gmd:DQ_DataQuality>
                      </gmd:dataQualityInfo>
                      <gmd:metadataMaintenance>
                          <gmd:MD_MaintenanceInformation>
                              <gmd:maintenanceAndUpdateFrequency>
                                  <gmd:MD_MaintenanceFrequencyCode codeList="http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#MD_MaintenanceFrequencyCode"
                                                       codeListValue="irregular">irregular</gmd:MD_MaintenanceFrequencyCode>
                              </gmd:maintenanceAndUpdateFrequency>
                              <gmd:maintenanceNote>
                                  <gco:CharacterString>Translated from ECHO using ECHOToISO.xsl Version: 1.32 (Dec. 9, 2015)</gco:CharacterString>
                              </gmd:maintenanceNote>
                          </gmd:MD_MaintenanceInformation>
                      </gmd:metadataMaintenance>
                      <gmi:acquisitionInformation>
                          <gmi:MI_AcquisitionInformation/>
                      </gmi:acquisitionInformation>
                  </gmi:MI_Metadata>
              </result>
          </results>
    eos
    document = Nokogiri::XML(response_xml)
    new_doc = BaseCswModel.add_cwic_keywords document
    expect(new_doc.root.xpath('/results/result/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()="CWIC > CEOS WGISS Integrated Catalog"', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gco' => 'http://www.isotc211.org/2005/gco')).to eq(false)
  end
end