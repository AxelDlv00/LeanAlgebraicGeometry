---
author: sync
content_type: class
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.Scheme.PicScheme.`HasAbelMap`
file: AlgebraicJacobian/Picard/FGAPicRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.`HasAbelMap`
type: lean
updated: '2026-07-24T17:02:56'
---
class `HasAbelMap` is repinned to **carry the map itself** (a data field
`abel`, no longer a bare `Prop`), so that `abelMap` acquires a genuine defining
property (`abelMap_app_mk` below) rather than being an opaque `Classical.choice`
of a `Nonempty`.

Construction of `abelMapWitness C : Div_{C/k} ⟶ Pic^♯_{C/k}`, `[D] ↦ [O(D)]`:
a relative effective divisor family `⟨F, q⟩` on `C ×_k T` has invertible ideal
`I_D = ker q`; the Abel map sends its class to
`[O(D)] = [I_D⁻¹] = -[I_D]`, the additive inverse (in the group-valued target
`Pic^♯_{C/k}(T)`) of the class of the ideal sheaf.  It is assembled as the
composite `abelKernelNatTrans C ≫ picNeg C`, where `abelKernelNatTrans` is the
substantive `[D] ↦ [I_D]` transformation and `picNeg` is the (natural)
negation on the group-valued functor.

Naturality of `abelKernelNatTrans` is the mathematical heart: for a test map
`g : T' ⟶ T` the base-change square is cartesian (`quotBaseSquare`), and the
**kernel–pullback comparison** `g_C^*(ker q) ⟶ ker(g_C^* q)` is an isomorphism
under the divisor conditions (`Modules.isIso_pullbackKernelComparison`, whose
side hypotheses — epi `q`, quasi-coherent source, finitely-presented `F`,
`T`-flat `F`, invertible kernel — are exactly the fields of `DivFamily`), so
`ker` commutes with base change and the class `[ker q]` is natural.  Negation
is natural because `Pic^♯`'s pullback maps are group homomorphisms.

The `dual` route (`Modules.dual (ker q)` as an explicit inverse) is available
for the *object-level* invertibility (`dual_isLocallyTrivial`) but is not used
here: the group-inverse `-[ker q]` is the canonical `[I_D⁻¹]` and makes
naturality rest only on the (landed) kernel–pullback comparison, avoiding the
not-yet-formalised sheaf-level dual-pullback commutation.

Blueprint reference: `lem:line_bundle_quot_correspondence` (Kleiman §3
Def. `dfn:Abel`); this instance is the **natural-transformation half** — `Div`
representability (Kleiman §3 Thm. `th:repDiv`) is NOT claimed here. -/