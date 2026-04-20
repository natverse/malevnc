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
#>   [1] "description_time"           "avg_location_time"         
#>   [3] "tosoma_position"            "avg_location_user"         
#>   [5] "predicted_nt_prob_user"     "neuropils_axonal_user"     
#>   [7] "subcluster_time"            "subclassabbr_user"         
#>   [9] "fru_dsx_user"               "hemilineage_time"          
#>  [11] "soma_side_time"             "reviewer"                  
#>  [13] "confidence_time"            "confidence_user"           
#>  [15] "predicted_nt_user"          "predicted_nt"              
#>  [17] "soma_side_user"             "neuropils_axonal"          
#>  [19] "status"                     "nt_glutamate_prob_user"    
#>  [21] "cluster"                    "position_type_user"        
#>  [23] "nt_unknown_prob"            "type"                      
#>  [25] "exit_nerve"                 "type_user"                 
#>  [27] "subclass_user"              "transmission_time"         
#>  [29] "typing_notes_time"          "entry_nerve_user"          
#>  [31] "nt_unknown_prob_user"       "group"                     
#>  [33] "soma_neuromere"             "modality_user"             
#>  [35] "origin_time"                "old_bodyids_user"          
#>  [37] "neuropils_dendritic_user"   "synonyms_time"             
#>  [39] "systematic_type"            "nt_glutamate_prob_time"    
#>  [41] "origin"                     "subclass"                  
#>  [43] "bodyid"                     "transmission"              
#>  [45] "position_time"              "root_side"                 
#>  [47] "neuropils_dendritic_time"   "user"                      
#>  [49] "nt_acetylcholine_prob_time" "user_user"                 
#>  [51] "target_user"                "receptor_type_user"        
#>  [53] "reviewer_time"              "birthtime_user"            
#>  [55] "root_side_user"             "source_user"               
#>  [57] "root_position"              "group_old_user"            
#>  [59] "group_time"                 "class_user"                
#>  [61] "naming_user_user"           "description_user"          
#>  [63] "user_time"                  "position_user"             
#>  [65] "tosoma_position_user"       "to_review_user"            
#>  [67] "root_side_time"             "source_time"               
#>  [69] "vfb_id_time"                "nt_gaba_prob_user"         
#>  [71] "synonyms"                   "instance_time"             
#>  [73] "systematic_type_user"       "synonyms_user"             
#>  [75] "target_time"                "serial"                    
#>  [77] "soma_position_time"         "transmission_user"         
#>  [79] "exit_nerve_time"            "target"                    
#>  [81] "class_time"                 "tag"                       
#>  [83] "class"                      "soma_neuromere_time"       
#>  [85] "position"                   "subcluster"                
#>  [87] "root_position_user"         "subclassabbr"              
#>  [89] "source"                     "predicted_nt_prob"         
#>  [91] "typing_notes_user"          "instance_user"             
#>  [93] "subclass_time"              "to_review_time"            
#>  [95] "instance"                   "root_position_time"        
#>  [97] "group_old"                  "prefix_user"               
#>  [99] "nt_acetylcholine_prob_user" "neuropils_axonal_time"     
#> [101] "confidence"                 "hemilineage"               
#> [103] "receptor_type"              "birthtime"                 
#> [105] "nt_glutamate_prob"          "hemilineage_user"          
#> [107] "subclassabbr_time"          "type_time"                 
#> [109] "to_review"                  "position_type"             
#> [111] "serial_motif_user"          "long_tract"                
#> [113] "prefix"                     "tosoma_position_time"      
#> [115] "old_bodyids"                "group_user"                
#> [117] "tag_user"                   "serial_user"               
#> [119] "modality"                   "typing_notes"              
#> [121] "old_bodyids_time"           "entry_nerve"               
#> [123] "cluster_time"               "reviewer_user"             
#> [125] "description"                "serial_motif_time"         
#> [127] "group_old_time"             "nt_gaba_prob_time"         
#> [129] "receptor_type_time"         "vfb_id_user"               
#> [131] "soma_position_user"         "soma_side"                 
#> [133] "nt_gaba_prob"               "fru_dsx_time"              
#> [135] "soma_neuromere_user"        "cluster_user"              
#> [137] "status_user"                "nt_unknown_prob_time"      
#> [139] "predicted_nt_prob_time"     "modality_time"             
#> [141] "avg_location"               "status_time"               
#> [143] "serial_motif"               "position_type_time"        
#> [145] "neuropils_dendritic"        "birthtime_time"            
#> [147] "systematic_type_time"       "nt_acetylcholine_prob"     
#> [149] "long_tract_time"            "soma_position"             
#> [151] "subcluster_user"            "predicted_nt_time"         
#> [153] "exit_nerve_user"            "entry_nerve_time"          
#> [155] "naming_user"                "prefix_time"               
#> [157] "origin_user"                "long_tract_user"           
#> [159] "naming_user_time"           "serial_time"               
#> [161] "tag_time"                   "vfb_id"                    
#> [163] "fru_dsx"                   
```
