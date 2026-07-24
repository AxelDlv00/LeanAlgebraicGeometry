---
author: sync
content_type: definition
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.Scheme.Modules.stratumι
docstring: The closed immersion of the rank-`e` stratum.
file: AlgebraicJacobian/Picard/EntryIdealStratum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.stratumι
type: lean
updated: '2026-07-24T17:02:56'
---
noncomputable def stratumι (hcov : ChartsCover G e) :
    stratum G e hcov ⟶ X :=
  (strataData G e hcov).subschemeι

instance (hcov : ChartsCover G e) :
    IsClosedImmersion (stratumι G e hcov) :=
  inferInstanceAs (IsClosedImmersion (strataData G e hcov).subschemeι)