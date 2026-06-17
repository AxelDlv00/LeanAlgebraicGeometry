# Picard/RelPicFunctor.lean — iter-246 (Lane RPF, prover-mode: prove)

## PicSharp.addCommGroup (was L235, opaque `exact sorry`)

### Architectural finding (blocks the objectives' recipe as written)
The iter-246 objectives told this lane to build `addCommGroup` by **citing**
`tensorObjOnProduct` / `exists_tensorObj_inverse` / the unitors-braiding-associator
from `Picard/TensorObjSubstrate.lean`. **This is impossible.** The dependency DAG is

```
Mathlib → LineBundlePullback → RelPicFunctor → {StalkTensor, Vestigial,
PresheafInternalHom} → TensorObjSubstrate
```

i.e. **`TensorObjSubstrate.lean:9` imports `RelPicFunctor`**, so the entire tensor
substrate lives strictly *downstream* of my file and cannot be referenced here
(citing it = an import cycle). `TensorObjSubstrate` even carries a sibling
`PicSharp.addCommGroup_via_tensorObj` (def, `sorry`, L1403) whose comment claims
"the RPF instance closes against it" — also impossible (downstream).

Second finding: the carrier setoid `RelPicPresheaf.preimage_subgroup`
(`LineBundlePullback.lean:349`) is the **iso-class** equivalence
`Nonempty (L.carrier ≅ L'.carrier)`, NOT the quotient-by-`H_T` relation. So
`Quotient (preimage_subgroup πC πT)` is `Pic(C×_S T)` itself and the honest group is
the tensor-product Picard group (additive mirror of `picCommGroup`). The blueprint's
Step 2–4 (`pullbackHom`, `H_T := pullbackHom.range`, setoid reconciliation,
transport) describe a *different future carrier* and do not apply here.

### What I did (RESOLVED into a real construction modulo named bridges)
Replaced the opaque `exact sorry` with a **genuine `AddCommGroup` construction**
built from a local substrate (pure-Mathlib copies, since the downstream originals
are unreachable):

- **Real, sorry-free:** `pTensor` (operation), `pTensorIso` (bifunctoriality),
  `pLeftUnitor`, `pRightUnitor`, `pBraiding`, `pUnitIso`, `pInverseUnique`,
  `relTensorObj`, `relAdd` (+ well-definedness), `relNeg` (+ well-definedness).
- **Group instance:** `add`, `zero`, `neg`, `nsmul := nsmulRec`, `zsmul := zsmulRec`
  (supplied via a `letI` Zero/Add/Neg block — `AddMonoid.nsmul` has no field default,
  `Group/Defs.lean:641`). Axioms `add_comm`, `zero_add`, `add_zero` are fully
  `sorry`-free; `add_assoc`, `neg_add_cancel` are genuine `Quotient.sound` proofs
  modulo the bridges below.

### Four named typed-`sorry` bridges (file 1 sorry → 4 sorries)
1. `pTensor_isLocallyTrivial` (L291) — pure-Mathlib (= downstream `tensorObj_isLocallyTrivial`
   via `tensorObj_restrict_iso`); bridged to avoid copying ~120 LOC upstream.
2. `pAssoc` (L300) — associator; pure-Mathlib via `Vestigial.lean` (= downstream
   `tensorObj_assoc_iso`); bridged to avoid duplicating the whiskering apparatus.
3. `isLocallyTrivial_unit` (L327) — TRIVIAL math; the intended proof is in its docstring
   but the Mathlib instance `[F.Final] : IsIso (pullbackObjUnitToUnit φ)`
   (`PullbackFree.lean:105`) refuses to synthesize for `φ = W.ι.toRingCatSheafHom`
   even though `Final`, `(pushforward φ).IsRightAdjoint`, `J/K.HasSheafCompose` all
   resolve (verified individually via `inferInstance`). The IDENTICAL
   `asIso (pullbackObjUnitToUnit g.toRingCatSheafHom)` compiles inside the proven
   `IsLocallyTrivial.pullback` (`LineBundlePullback.lean:192`). Undiagnosed
   resolution quirk — pinning `.{u}` and naming the instance both failed.
4. `exists_pTensor_inverse` (L336) — `sorry` everywhere (the tracked reverse bridge
   `IsLocallyTrivial ⟹ IsInvertible`, = `exists_tensorObj_inverse`,
   `TensorObjSubstrate.lean:672`).

Verified: `lake build AlgebraicJacobian.Picard.RelPicFunctor` ✓ and downstream
`lake build AlgebraicJacobian.Picard.TensorObjSubstrate` ✓ (no breakage; the local
substrate decls are `private` so they cannot collide with the downstream namesakes).

## PicSharp.functorial (L… , currently `0`)
NOT upgraded. The real pullback-descended `AddMonoidHom` needs `map_zero` ←
`pullbackUnitIso` and `map_add` ← the comparison iso `π^*(N⊗N')≅π^*N⊗π^*N'`, BOTH of
which are the downstream-gated substrate (same import blocker). Upgrading would add
2 more downstream-gated bridges to a declaration that currently has no sorry; deferred
pending the architecture fix.

## Recommended planner action (architectural, spans >1 file — not in my write-domain)
Either (a) **move the tensor substrate** (`tensorObj`, `tensorObjIsoOfIso`, unitors,
braiding, `tensorObj_assoc_iso`, `tensorObj_isLocallyTrivial`, `tensorObjOnProduct`,
`exists_tensorObj_inverse`) to a file **upstream** of `RelPicFunctor` (e.g. split a
`Picard/TensorSubstrate.lean` that `LineBundlePullback`-level files can import), then
the four local bridges collapse to direct citations and the construction is real
modulo only `exists_tensorObj_inverse`; **or** (b) **relocate the
`PicSharp.addCommGroup` instance downstream** into `TensorObjSubstrate` next to
`addCommGroup_via_tensorObj` (a structural subagent can move a non-protected
declaration). Option (a) is preferred (keeps the blueprint pin in this chapter's file).

## Blueprint
`lem:rel_pic_sharp_groupoid` (`\lean{...PicSharp.addCommGroup}`): the body is now a
real construction (not opaque), but NOT axiom-clean (4 `sorry` bridges) — do **not**
`\leanok` the proof yet. The deterministic `sync_leanok` will see the sorries and
leave it unmarked, which is correct.

## Summary
- **sorry count: 1 → 4** (raw count up), but the assigned `addCommGroup` sorry is
  REPLACED by a genuine `AddCommGroup` construction; the 4 sorries are named leaf
  bridges, two of them pure-Mathlib-replicable and two cross-lane/project-deferred.
- Closed (as real, sorry-free declarations): `pTensor`, `pTensorIso`, `pLeftUnitor`,
  `pRightUnitor`, `pBraiding`, `pUnitIso`, `pInverseUnique`, `relTensorObj`, `relAdd`,
  `relNeg`, and the `addCommGroup` instance body (group axioms `add_comm`/`zero_add`/
  `add_zero` fully proven; `add_assoc`/`neg_add_cancel` proven modulo bridges).
- Still open: the 4 bridges named above; `functorial` left at `0` (needs downstream
  substrate). Attempted `isLocallyTrivial_unit` directly (failed on a Mathlib IsIso
  instance-resolution quirk — documented).
- Adjacent sorries: the only sorries in-file are now the 4 bridges I introduced;
  `functorial`/`presheaf`/`etSheaf`/`etSheaf_group_structure` are placeholders, not
  sorries, and upgrading them is downstream-gated.

## Why I stopped
**Partial progress (genuine code).** I converted the assigned opaque `exact sorry`
(`PicSharp.addCommGroup`) into a real, compiling `AddCommGroup` construction — the
operation, both well-definedness proofs, and three of the five group axioms are fully
`sorry`-free; the remaining two axioms are genuine `Quotient.sound` proofs modulo four
*named, typed* bridges. This is a real advance over the opaque sorry, not a rename.

I did **not** make the construction fully axiom-clean because the objectives' route
(cite `TensorObjSubstrate` decls) is **infeasible**: `TensorObjSubstrate` imports
`RelPicFunctor`, so the tensor substrate is downstream and unreachable. Of the four
bridges, two (`pAssoc`, `pTensor_isLocallyTrivial`) are pure-Mathlib-replicable but
would require importing `Vestigial` and copying ~200 LOC of intricate, downstream-proven
substrate verbatim into this upstream file — fragile duplication that is the wrong fix;
one (`isLocallyTrivial_unit`) is trivial but blocked by an undiagnosed Mathlib `IsIso`
instance-resolution quirk (attempted directly, documented); one (`exists_pTensor_inverse`)
is a `sorry` project-wide. The proper resolution is architectural (relocate the substrate
upstream, or the instance downstream) and is the planner's call — it spans files outside
my write-domain. Informal agent unavailable (`informal-agent-key-invalid`: HTTP 401).
