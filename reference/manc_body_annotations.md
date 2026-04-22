# Return clio-store body annotations for set of ids or a flexible query

`clio_fields` returns all the fields currently known to exist in the
clio store for a given dataset. A short description...

## Usage

``` r
manc_body_annotations(
  ids = NULL,
  query = NULL,
  json = FALSE,
  config = NULL,
  cache = FALSE,
  update.bodyids = FALSE,
  test = FALSE,
  show.extra = c("none", "user", "time", "all"),
  ...
)

clio_fields(dataset = getOption("malevnc.dataset"))
```

## Arguments

- ids:

  A set of body ids in any form understandable to
  [`manc_ids`](https://natverse.org/malevnc/reference/manc_ids.md)

- query:

  A json query string (see examples or documentation) or an R list with
  field names as elements.

- json:

  Whether to return unparsed JSON rather than an R list (default
  `FALSE`).

- config:

  An optional httr::config (expert use only, must include a bearer
  token)

- cache:

  Whether to cache the result of this call for 5 minutes.

- update.bodyids:

  Whether to update the bodyid associated with annotations based on the
  position field. The default value of this has been switched to `FALSE`
  as of Feb 2022.

- test:

  Whether to unset the clio-store test server (default `FALSE`)

- show.extra:

  Extra columns to show with user/timestamp information.

- ...:

  Additional arguments passed to
  [`pbapply::pblapply`](https://peter.solymos.org/pbapply/reference/pbapply.html)

- dataset:

  short name of the dataset (VNC or CNS)

## Value

An R data.frame or a character vector containing JSON (when
`json=TRUE`). Two additional fields will be added

- original.bodyid When `update.bodyids=TRUE` this field contains the
  original bodyid from Clio whereas `bodyid` contains the updated value
  implied by the position.

- `auto` `TRUE` signals that the record contains only data automatically
  copied over from DVID without any manual annotation.

  See
  [slack](https://flyem-cns.slack.com/archives/C01MYQ1AQ5D/p1628214375055400)
  for details of the position / position type fields.

## Details

Missing values in each output column are filled with NA. But if a whole
column is missing from the results of a particular query then it will
not appear at all.

When neither `query` and `ids` are missing then we return all entries in
the clio store database. This currently includes annotations for all
body ids - even the ones that are no longer current.

## See also

[swagger docs](https://clio-store-vwzoicitea-uk.a.run.app/docs) or
[basic docs from Bill
Katz](https://docs.google.com/document/d/14wzFX6cMf0JcR0ozf7wmufNoUcVtlruzUo5BdAgdM-g/edit).

Other manc-annotation:
[`manc_annotate_body()`](https://natverse.org/malevnc/reference/manc_annotate_body.md),
[`manc_meta()`](https://natverse.org/malevnc/reference/manc_meta.md),
[`manc_point_annotations()`](https://natverse.org/malevnc/reference/manc_point_annotations.md)

## Examples

``` r
if (FALSE) { # \dontrun{
manc_body_annotations(ids=11442)
manc_body_annotations(ids=11442, show.extra='user')
manc_body_annotations(query='{"hemilineage": "0B"}')
manc_body_annotations(query=list(user="janedoe@gmail.com"))
manc_body_annotations(query=list(soma_side="RHS"))
manc_body_annotations(ids=manc_xyz2bodyid(mancneckseeds))
# use clio node to ensure for bodyid consistency
manc_body_annotations(ids=
  manc_xyz2bodyid(mancneckseeds, node="clio"))

# fetch all bodyids
mba=manc_body_annotations()
} # }
clio_fields()
#>   [1] "nt_acetylcholine_prob_user" "position_type_user"        
#>   [3] "subcluster"                 "group_old_user"            
#>   [5] "nt_unknown_prob_user"       "subclass"                  
#>   [7] "type_user"                  "group"                     
#>   [9] "status_time"                "cluster"                   
#>  [11] "fru_dsx"                    "modality_time"             
#>  [13] "status"                     "prefix_time"               
#>  [15] "long_tract"                 "to_review_user"            
#>  [17] "hemilineage_time"           "vfb_id_time"               
#>  [19] "instance_user"              "nt_gaba_prob_user"         
#>  [21] "root_position_time"         "transmission"              
#>  [23] "nt_gaba_prob"               "predicted_nt"              
#>  [25] "fru_dsx_user"               "type"                      
#>  [27] "synonyms"                   "predicted_nt_prob_time"    
#>  [29] "transmission_user"          "subclassabbr_user"         
#>  [31] "systematic_type"            "predicted_nt_prob"         
#>  [33] "origin"                     "typing_notes"              
#>  [35] "position_user"              "subclassabbr"              
#>  [37] "position_type"              "origin_user"               
#>  [39] "source_time"                "soma_position_time"        
#>  [41] "soma_neuromere_user"        "hemilineage_user"          
#>  [43] "predicted_nt_time"          "predicted_nt_prob_user"    
#>  [45] "naming_user_time"           "root_side"                 
#>  [47] "old_bodyids"                "reviewer_time"             
#>  [49] "instance_time"              "vfb_id_user"               
#>  [51] "status_user"                "serial_motif"              
#>  [53] "transmission_time"          "serial"                    
#>  [55] "neuropils_axonal_time"      "cluster_user"              
#>  [57] "nt_acetylcholine_prob_time" "description_time"          
#>  [59] "typing_notes_user"          "nt_glutamate_prob_time"    
#>  [61] "avg_location"               "entry_nerve"               
#>  [63] "predicted_nt_user"          "description"               
#>  [65] "entry_nerve_user"           "neuropils_axonal_user"     
#>  [67] "typing_notes_time"          "modality_user"             
#>  [69] "receptor_type"              "reviewer_user"             
#>  [71] "serial_motif_user"          "target_user"               
#>  [73] "origin_time"                "user_user"                 
#>  [75] "exit_nerve_time"            "soma_neuromere_time"       
#>  [77] "root_position"              "naming_user"               
#>  [79] "class_time"                 "subclass_user"             
#>  [81] "reviewer"                   "entry_nerve_time"          
#>  [83] "tosoma_position_time"       "target_time"               
#>  [85] "birthtime_user"             "synonyms_time"             
#>  [87] "nt_unknown_prob"            "avg_location_time"         
#>  [89] "receptor_type_time"         "subcluster_time"           
#>  [91] "birthtime"                  "systematic_type_user"      
#>  [93] "root_position_user"         "nt_gaba_prob_time"         
#>  [95] "tag_time"                   "neuropils_dendritic_user"  
#>  [97] "instance"                   "user"                      
#>  [99] "serial_user"                "description_user"          
#> [101] "neuropils_dendritic_time"   "naming_user_user"          
#> [103] "type_time"                  "group_time"                
#> [105] "root_side_time"             "neuropils_dendritic"       
#> [107] "confidence"                 "to_review_time"            
#> [109] "prefix"                     "class"                     
#> [111] "source"                     "nt_glutamate_prob"         
#> [113] "nt_glutamate_prob_user"     "old_bodyids_user"          
#> [115] "nt_unknown_prob_time"       "group_user"                
#> [117] "receptor_type_user"         "cluster_time"              
#> [119] "subcluster_user"            "old_bodyids_time"          
#> [121] "vfb_id"                     "fru_dsx_time"              
#> [123] "birthtime_time"             "avg_location_user"         
#> [125] "tosoma_position"            "root_side_user"            
#> [127] "group_old_time"             "confidence_time"           
#> [129] "class_user"                 "soma_side"                 
#> [131] "tag_user"                   "source_user"               
#> [133] "serial_time"                "nt_acetylcholine_prob"     
#> [135] "hemilineage"                "group_old"                 
#> [137] "soma_position"              "synonyms_user"             
#> [139] "soma_position_user"         "subclass_time"             
#> [141] "confidence_user"            "exit_nerve_user"           
#> [143] "soma_neuromere"             "modality"                  
#> [145] "prefix_user"                "systematic_type_time"      
#> [147] "target"                     "to_review"                 
#> [149] "position"                   "user_time"                 
#> [151] "subclassabbr_time"          "bodyid"                    
#> [153] "serial_motif_time"          "neuropils_axonal"          
#> [155] "tag"                        "tosoma_position_user"      
#> [157] "long_tract_time"            "soma_side_user"            
#> [159] "soma_side_time"             "long_tract_user"           
#> [161] "position_time"              "position_type_time"        
#> [163] "exit_nerve"                
```
