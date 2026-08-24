---
author: sync
content_type: theorem
created: '2026-07-29T12:33:17'
decl: AlgebraicGeometry.epsFamilyEq
docstring: the family equality
file: scratch_t36d.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.epsFamilyEq
type: lean
updated: '2026-07-29T13:28:47'
---
theorem epsFamilyEq :
    (fun s ↦ relCurveMap C (DualNumber k) k ⁻¹ᵁ
      (fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ U s)
    = fun s ↦ (fst C (overSpec k k)).left ⁻¹ᵁ U s :=
  funext fun s ↦ relCurveMap_preimage C (DualNumber k) k (U s)

set_option maxHeartbeats 1000000 in
/-- TIMING PROBE 1: just the LHS type -/
example
    (hc : ∀ s, IsCompact ((U s : Set C.left))) (hq : ∀ s, IsQuasiSeparated ((U s : Set C.left)))
    (hci : IsCompact (((U false ⊓ U true : C.left.Opens) : Set C.left)))
    (hqi : IsQuasiSeparated (((U false ⊓ U true : C.left.Opens) : Set C.left)))
    (q : (Γ(C.left, U false ⊓ U true)[ε])ˣ ⧸ cechCoboundaryUnits
        (mapRingHom (C.left.resHom (inf_le_left : U false ⊓ U true ≤ U false)))
        (mapRingHom (C.left.resHom (inf_le_right : U false ⊓ U true ≤ U true)))) :
    True := by
  have _lhs := Scheme.pullbackOverlapQuot
        (V := fun s ↦ (fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ U s)
        (relCurveMap C (DualNumber k) k)
        (Over.dualNumberCechH1Equiv C hc hq hci hqi q)
  trivial

set_option maxHeartbeats 1000000 in
/-- TIMING PROBE 2: just the RHS -/
example
    (hc : ∀ s, IsCompact ((U s : Set C.left))) (hq : ∀ s, IsQuasiSeparated ((U s : Set C.left)))
    (hci : IsCompact (((U false ⊓ U true : C.left.Opens) : Set C.left)))
    (hqi : IsQuasiSeparated (((U false ⊓ U true : C.left.Opens) : Set C.left)))
    (q : (Γ(C.left, U false ⊓ U true)[ε])ˣ ⧸ cechCoboundaryUnits
        (mapRingHom (C.left.resHom (inf_le_left : U false ⊓ U true ≤ U false)))
        (mapRingHom (C.left.resHom (inf_le_right : U false ⊓ U true ≤ U true)))) :
    True := by
  have _rhs := (overlapQuotCongr (epsFamilyEq C U)).symm
          (collapseCechH1Equiv C hc hq hci hqi
            (TwoCover.unitsReduction C.left (U false) (U true) q))
  trivial