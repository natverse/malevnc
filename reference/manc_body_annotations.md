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
#>   [1] "predicted_nt_prob_user"     "source_user"               
#>   [3] "nt_glutamate_prob_user"     "neuropils_dendritic_user"  
#>   [5] "long_tract_user"            "tag"                       
#>   [7] "synonyms_user"              "position_type_user"        
#>   [9] "confidence_user"            "bodyid"                    
#>  [11] "origin"                     "reviewer_user"             
#>  [13] "neuropils_axonal"           "serial"                    
#>  [15] "nt_gaba_prob_time"          "group"                     
#>  [17] "prefix_user"                "soma_neuromere_user"       
#>  [19] "description_time"           "predicted_nt"              
#>  [21] "vfb_id_user"                "position"                  
#>  [23] "position_type"              "class_time"                
#>  [25] "naming_user_time"           "predicted_nt_prob"         
#>  [27] "position_time"              "user_time"                 
#>  [29] "cluster"                    "old_bodyids_user"          
#>  [31] "birthtime_time"             "tag_user"                  
#>  [33] "position_user"              "source"                    
#>  [35] "serial_motif"               "group_time"                
#>  [37] "root_side"                  "instance_user"             
#>  [39] "reviewer"                   "root_position_time"        
#>  [41] "typing_notes_user"          "group_old_time"            
#>  [43] "group_old_user"             "nt_unknown_prob_user"      
#>  [45] "old_bodyids"                "reviewer_time"             
#>  [47] "position_type_time"         "modality_user"             
#>  [49] "instance"                   "subclass"                  
#>  [51] "user_user"                  "tag_time"                  
#>  [53] "subclass_user"              "nt_gaba_prob"              
#>  [55] "serial_motif_user"          "nt_glutamate_prob"         
#>  [57] "exit_nerve_time"            "type"                      
#>  [59] "class_user"                 "group_old"                 
#>  [61] "soma_neuromere"             "receptor_type_user"        
#>  [63] "tosoma_position_time"       "naming_user"               
#>  [65] "nt_gaba_prob_user"          "serial_user"               
#>  [67] "instance_time"              "cluster_time"              
#>  [69] "exit_nerve"                 "vfb_id_time"               
#>  [71] "nt_unknown_prob_time"       "nt_unknown_prob"           
#>  [73] "tosoma_position_user"       "entry_nerve_time"          
#>  [75] "prefix_time"                "root_side_time"            
#>  [77] "subclassabbr"               "status_time"               
#>  [79] "transmission_time"          "root_position"             
#>  [81] "hemilineage_time"           "subcluster"                
#>  [83] "source_time"                "nt_acetylcholine_prob_user"
#>  [85] "birthtime_user"             "entry_nerve_user"          
#>  [87] "subcluster_time"            "subcluster_user"           
#>  [89] "modality_time"              "nt_acetylcholine_prob_time"
#>  [91] "predicted_nt_user"          "tosoma_position"           
#>  [93] "description_user"           "to_review_user"            
#>  [95] "origin_user"                "fru_dsx_time"              
#>  [97] "subclassabbr_user"          "target_time"               
#>  [99] "soma_side_user"             "birthtime"                 
#> [101] "confidence"                 "systematic_type_time"      
#> [103] "user"                       "long_tract_time"           
#> [105] "avg_location_time"          "target"                    
#> [107] "soma_position_user"         "typing_notes_time"         
#> [109] "to_review_time"             "predicted_nt_prob_time"    
#> [111] "transmission_user"          "fru_dsx_user"              
#> [113] "nt_glutamate_prob_time"     "avg_location"              
#> [115] "class"                      "long_tract"                
#> [117] "synonyms_time"              "exit_nerve_user"           
#> [119] "hemilineage_user"           "neuropils_dendritic_time"  
#> [121] "nt_acetylcholine_prob"      "subclassabbr_time"         
#> [123] "systematic_type_user"       "soma_position"             
#> [125] "description"                "root_position_user"        
#> [127] "receptor_type_time"         "entry_nerve"               
#> [129] "old_bodyids_time"           "origin_time"               
#> [131] "confidence_time"            "typing_notes"              
#> [133] "soma_side"                  "modality"                  
#> [135] "type_user"                  "vfb_id"                    
#> [137] "transmission"               "fru_dsx"                   
#> [139] "soma_side_time"             "avg_location_user"         
#> [141] "hemilineage"                "synonyms"                  
#> [143] "prefix"                     "soma_neuromere_time"       
#> [145] "neuropils_axonal_user"      "status_user"               
#> [147] "serial_motif_time"          "group_user"                
#> [149] "predicted_nt_time"          "serial_time"               
#> [151] "receptor_type"              "to_review"                 
#> [153] "naming_user_user"           "soma_position_time"        
#> [155] "subclass_time"              "root_side_user"            
#> [157] "type_time"                  "neuropils_dendritic"       
#> [159] "cluster_user"               "neuropils_axonal_time"     
#> [161] "status"                     "systematic_type"           
#> [163] "target_user"               
```
