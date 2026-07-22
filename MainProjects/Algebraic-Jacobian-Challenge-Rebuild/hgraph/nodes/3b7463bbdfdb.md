---
author: sync
content_type: theorem
created: '2026-07-21T23:32:09'
decl: Submodule.directLimitQuotientToIdeal_of_mk
file: AlgebraicJacobian/Picard/DivSchemeHighWindowDirectLimit.lean
generated: lean
lean_status: lean_ok
title: Submodule.directLimitQuotientToIdeal_of_mk
type: lean
updated: '2026-07-21T23:32:09'
---
theorem directLimitQuotientToIdeal_of_mk (i : ι) (x : G i) :
    directLimitQuotientToIdeal f K hK read J hreadK hread
        (Module.DirectLimit.of R ι _
          (directedQuotientMapOfCompatible f K hK) i
          (Submodule.Quotient.mk x)) =
      Ideal.Quotient.mk J (read i x) := by
  rw [directLimitQuotientToIdeal, Module.DirectLimit.lift_of,
    quotientReadMap_mk]

include hreadK hread in