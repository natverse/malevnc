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
#>   [1] "nt_glutamate_prob_time"     "neuropils_dendritic"       
#>   [3] "confidence"                 "nt_gaba_prob_user"         
#>   [5] "transmission_time"          "soma_position"             
#>   [7] "type_time"                  "fru_dsx_time"              
#>   [9] "user_time"                  "long_tract_time"           
#>  [11] "subclassabbr"               "serial_user"               
#>  [13] "prefix_time"                "root_position_time"        
#>  [15] "predicted_nt_prob_user"     "old_bodyids_user"          
#>  [17] "class_user"                 "nt_acetylcholine_prob_user"
#>  [19] "nt_gaba_prob"               "target"                    
#>  [21] "soma_position_time"         "source_time"               
#>  [23] "synonyms"                   "nt_acetylcholine_prob"     
#>  [25] "predicted_nt_time"          "root_position"             
#>  [27] "position_type_user"         "group_old_user"            
#>  [29] "to_review_user"             "tag"                       
#>  [31] "user"                       "to_review_time"            
#>  [33] "soma_neuromere_user"        "birthtime"                 
#>  [35] "matching_notes"             "origin"                    
#>  [37] "receptor_type_user"         "avg_location_time"         
#>  [39] "neuropils_dendritic_time"   "systematic_type_time"      
#>  [41] "subclass_user"              "cluster_time"              
#>  [43] "status"                     "synonyms_user"             
#>  [45] "nt_unknown_prob"            "synonyms_time"             
#>  [47] "soma_side"                  "cluster"                   
#>  [49] "tosoma_position"            "subclass"                  
#>  [51] "instance_user"              "matching_notes_time"       
#>  [53] "naming_user"                "root_side_user"            
#>  [55] "serial_motif"               "modality_time"             
#>  [57] "serial"                     "type"                      
#>  [59] "neuropils_axonal_user"      "entry_nerve_time"          
#>  [61] "receptor_type"              "naming_user_user"          
#>  [63] "birthtime_user"             "origin_user"               
#>  [65] "nt_gaba_prob_time"          "long_tract_user"           
#>  [67] "vfb_id_time"                "avg_location_user"         
#>  [69] "exit_nerve_time"            "soma_position_user"        
#>  [71] "modality"                   "position_user"             
#>  [73] "nt_glutamate_prob"          "neuropils_axonal"          
#>  [75] "reviewer"                   "subclass_time"             
#>  [77] "user_user"                  "birthtime_time"            
#>  [79] "fru_dsx_user"               "tag_time"                  
#>  [81] "long_tract"                 "class_time"                
#>  [83] "position_type_time"         "status_user"               
#>  [85] "root_side"                  "group_old_time"            
#>  [87] "tag_user"                   "fru_dsx"                   
#>  [89] "origin_time"                "to_review"                 
#>  [91] "receptor_type_time"         "cluster_user"              
#>  [93] "group_old"                  "nt_acetylcholine_prob_time"
#>  [95] "vfb_id_user"                "predicted_nt_prob_time"    
#>  [97] "predicted_nt_user"          "tosoma_position_time"      
#>  [99] "serial_time"                "reviewer_time"             
#> [101] "modality_user"              "naming_user_time"          
#> [103] "typing_notes"               "nt_glutamate_prob_user"    
#> [105] "description"                "group_user"                
#> [107] "position_time"              "confidence_time"           
#> [109] "matching_notes_user"        "predicted_nt"              
#> [111] "instance_time"              "source"                    
#> [113] "status_time"                "exit_nerve"                
#> [115] "neuropils_axonal_time"      "entry_nerve_user"          
#> [117] "systematic_type"            "subclassabbr_user"         
#> [119] "nt_unknown_prob_user"       "confidence_user"           
#> [121] "class"                      "soma_neuromere"            
#> [123] "group"                      "nt_unknown_prob_time"      
#> [125] "old_bodyids"                "hemilineage"               
#> [127] "description_user"           "typing_notes_user"         
#> [129] "group_time"                 "root_position_user"        
#> [131] "target_time"                "hemilineage_time"          
#> [133] "typing_notes_time"          "root_side_time"            
#> [135] "entry_nerve"                "position"                  
#> [137] "prefix_user"                "description_time"          
#> [139] "type_user"                  "transmission_user"         
#> [141] "soma_side_user"             "soma_side_time"            
#> [143] "predicted_nt_prob"          "tosoma_position_user"      
#> [145] "transmission"               "subcluster"                
#> [147] "subcluster_user"            "bodyid"                    
#> [149] "instance"                   "source_user"               
#> [151] "prefix"                     "hemilineage_user"          
#> [153] "neuropils_dendritic_user"   "old_bodyids_time"          
#> [155] "target_user"                "position_type"             
#> [157] "avg_location"               "serial_motif_user"         
#> [159] "serial_motif_time"          "reviewer_user"             
#> [161] "subcluster_time"            "subclassabbr_time"         
#> [163] "exit_nerve_user"            "vfb_id"                    
#> [165] "soma_neuromere_time"        "systematic_type_user"      
```
