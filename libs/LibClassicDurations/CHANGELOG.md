# LibClassicDurations

## [1.52](https://github.com/rgd87/LibClassicDurations/tree/1.52) (2020-04-07)
[Full Changelog](https://github.com/rgd87/LibClassicDurations/compare/1.50...1.52)

- Typo fix  
- CoC Winter's Chill bugfix  
- rollback bugfix for WC and SW  
- Bump minor  
- Merge pull request #52 from SDPhantom/patch-1  
    Store activeFrames in lib table  
- Store activeFrames in lib table  
    Fixes earlier revisions forgetting what addons are registered when a new revision is loaded.  
    This issue would cause older registered addons to stop working if a newer one unregistered itself.  
- Rollback misses for Winter's Chill and Shadow Weaving  
