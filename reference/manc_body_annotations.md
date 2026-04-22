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
#>   [1] "prefix"                     "systematic_type_time"      
#>   [3] "soma_neuromere_user"        "avg_location_user"         
#>   [5] "nt_unknown_prob"            "transmission_user"         
#>   [7] "prefix_time"                "position_type_time"        
#>   [9] "nt_gaba_prob_time"          "nt_glutamate_prob_user"    
#>  [11] "type"                       "avg_location"              
#>  [13] "soma_side"                  "soma_position"             
#>  [15] "typing_notes_time"          "instance"                  
#>  [17] "subclassabbr_user"          "old_bodyids"               
#>  [19] "receptor_type_user"         "vfb_id_user"               
#>  [21] "nt_acetylcholine_prob"      "to_review_time"            
#>  [23] "nt_acetylcholine_prob_time" "neuropils_axonal_time"     
#>  [25] "serial"                     "typing_notes"              
#>  [27] "predicted_nt_time"          "tag_time"                  
#>  [29] "position_type"              "origin_user"               
#>  [31] "confidence"                 "class_user"                
#>  [33] "subclassabbr"               "position"                  
#>  [35] "subcluster_time"            "confidence_user"           
#>  [37] "instance_time"              "type_time"                 
#>  [39] "position_type_user"         "fru_dsx"                   
#>  [41] "receptor_type"              "origin"                    
#>  [43] "vfb_id_time"                "nt_gaba_prob_user"         
#>  [45] "user_user"                  "root_side"                 
#>  [47] "long_tract_user"            "soma_neuromere_time"       
#>  [49] "root_side_time"             "typing_notes_user"         
#>  [51] "receptor_type_time"         "transmission_time"         
#>  [53] "group_old"                  "group_user"                
#>  [55] "vfb_id"                     "hemilineage_time"          
#>  [57] "status_user"                "group_time"                
#>  [59] "nt_unknown_prob_time"       "root_position_user"        
#>  [61] "fru_dsx_user"               "nt_glutamate_prob_time"    
#>  [63] "reviewer_user"              "cluster_user"              
#>  [65] "source"                     "avg_location_time"         
#>  [67] "long_tract"                 "old_bodyids_time"          
#>  [69] "neuropils_dendritic_user"   "subcluster_user"           
#>  [71] "birthtime_time"             "tag"                       
#>  [73] "soma_neuromere"             "predicted_nt_user"         
#>  [75] "description"                "target_time"               
#>  [77] "serial_time"                "neuropils_axonal_user"     
#>  [79] "naming_user_time"           "position_user"             
#>  [81] "nt_glutamate_prob"          "tosoma_position_time"      
#>  [83] "exit_nerve"                 "exit_nerve_time"           
#>  [85] "entry_nerve_time"           "status_time"               
#>  [87] "confidence_time"            "modality_time"             
#>  [89] "user"                       "neuropils_dendritic_time"  
#>  [91] "entry_nerve_user"           "naming_user"               
#>  [93] "birthtime"                  "soma_position_time"        
#>  [95] "instance_user"              "long_tract_time"           
#>  [97] "root_side_user"             "old_bodyids_user"          
#>  [99] "serial_motif_user"          "fru_dsx_time"              
#> [101] "neuropils_axonal"           "systematic_type_user"      
#> [103] "prefix_user"                "hemilineage_user"          
#> [105] "subclass"                   "nt_gaba_prob"              
#> [107] "modality"                   "group"                     
#> [109] "to_review_user"             "serial_motif_time"         
#> [111] "tosoma_position_user"       "description_time"          
#> [113] "target_user"                "synonyms_time"             
#> [115] "class"                      "root_position_time"        
#> [117] "neuropils_dendritic"        "nt_acetylcholine_prob_user"
#> [119] "nt_unknown_prob_user"       "naming_user_user"          
#> [121] "entry_nerve"                "subclass_user"             
#> [123] "status"                     "reviewer_time"             
#> [125] "position_time"              "to_review"                 
#> [127] "hemilineage"                "predicted_nt_prob"         
#> [129] "cluster_time"               "synonyms_user"             
#> [131] "soma_position_user"         "class_time"                
#> [133] "serial_user"                "predicted_nt"              
#> [135] "tosoma_position"            "serial_motif"              
#> [137] "subclassabbr_time"          "source_time"               
#> [139] "soma_side_time"             "reviewer"                  
#> [141] "systematic_type"            "target"                    
#> [143] "predicted_nt_prob_user"     "subcluster"                
#> [145] "user_time"                  "bodyid"                    
#> [147] "root_position"              "type_user"                 
#> [149] "description_user"           "transmission"              
#> [151] "cluster"                    "group_old_user"            
#> [153] "tag_user"                   "source_user"               
#> [155] "birthtime_user"             "synonyms"                  
#> [157] "predicted_nt_prob_time"     "exit_nerve_user"           
#> [159] "origin_time"                "soma_side_user"            
#> [161] "subclass_time"              "group_old_time"            
#> [163] "modality_user"             
```
