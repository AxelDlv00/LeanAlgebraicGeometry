# Lean ↔ Blueprint Check Report

## Slug
lvb-tos257

## Iteration
257

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Focus
D3′ `pullbackTensorMap_restrict` (blueprint `lem:pullback_tensor_map_basechange`), plus
the new standalone helper `toRingCatSheafHom_comp_hom_reconcile`.

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (chapter: `\lem:pullback_tensor_map_basechange`)

- **Lean target exists**: yes (line 2148 of the Lean file)
- **Signature matches**: yes — the Lean signature is the general composition-coherence form
  ```
  pullbackTensorMap (h ≫ f) M N =
    (pullbackComp h f).inv.app (tensorObj M N) ≫
    (pullback h).map (pullbackTensorMap f M N) ≫
    pullbackTensorMap h ((pullback f).obj M) ((pullback f).obj N) ≫
    (tensorObjIsoOfIso ((pullbackComp h f).app M) ((pullbackComp h f).app N)).hom
  ```
  This matches the blueprint's four-term displayed equation exactly.
- **Proof follows sketch**: no — see red flags below
- **notes**:
  - Body is a typed `sorry` with a detailed roadmap comment (ITER-257 FINDINGS section).
  - The blueprint statement block carries `\leanok` (declaration exists with sorry) ✓. No
    proof-block `\leanok` is present ✓. Both markers are therefore consistent with the
    current state.
  - The Lean roadmap correctly explains *why* the unit-analog mirror (`pullbackObjUnitToUnit_comp`
    pattern) does NOT transfer: `pullbackTensorMap` is a hand-built four-fold composite, not an
    adjunction transpose, so `homEquiv.injective` stalls.

### `toRingCatSheafHom_comp_hom_reconcile` (private helper)

- **Lean target exists**: yes (line 2121, private)
- **Blueprint reference**: none — this is a private helper not `\lean{}`-pinned. Acceptable.
- **Signature matches**: N/A (not blueprint-pinned)
- **Proof follows sketch**: N/A; body is `rfl` (definitional).
- **notes**:
  - States `(Hom.toRingCatSheafHom (h ≫ f)).hom = (Hom.toRingCatSheafHom f).hom ≫ (Opens.map f.base).op.whiskerLeft (Hom.toRingCatSheafHom h).hom` and closes by `rfl`.
  - This is the "Sq2 ring-map reconciliation" that the blueprint characterises as "non-trivial". The Lean finds it is in fact definitional.

---

## Red flags

### Stale blueprint proof sketch — Sq2 ring-map reconciliation

**`Picard_TensorObjSubstrate.tex` lines ~3951–3958 (Sq2 paragraph):**

> *"which is non-trivial because the two sides live in functor categories that agree only
> up to the equality `Opens.map_(h.base ∘ f.base) = Opens.map_f.base ∘ Opens.map_h.base`
> (`Opens.map_comp`), so the reconciliation is transported by the pseudofunctor coherence.
> The bookkeeping atoms `{pullbackId, pullback_assoc, pullback_comp_id, pullback_id_comp}`
> discharge the residual associativity and unit squares."*

**Finding:** This claim is **false**. The Lean file (ITER-257 FINDINGS, finding (1)) shows that
`toRingCatSheafHom_comp_hom_reconcile` closes by `rfl` — the Scheme composition defeqs make both
sides definitionally equal. No transport by pseudofunctor coherence, no bookkeeping atoms, are
needed for this sub-step. The blueprint is actively misleading here.

Severity: **must-fix-this-iter** (stale/incorrect proof-sketch prose that misdirects future
prover work on D3′).

### Blueprint blueprint adequacy failure — Sq2b absent from sketch

**Finding:** The blueprint's Sq2 description stops at the ring-map reconciliation (which turned out
to be `rfl`) and does not name or describe the GENUINE hard step:

> "Sq2b": the **monoidality of `pullbackComp`** — i.e., that `δ` of the single
> `pullback φ'_{h≫f}` (leftAdjoint-oplax of the composite adjunction) transports, through
> `pullbackComp`, to `δ` of the composite functor `pullback φ'_f ⋙ pullback φ'_h`, via
> `Functor.OplaxMonoidal.comp_δ`.

The Lean roadmap (ITER-257 FINDINGS, finding (2)) identifies this as Mathlib-absent and requires
a mate-calculus proof mirroring `Adjunction.isMonoidal_comp` (Mathlib `Functor.lean:990`). The
blueprint sketch gives no hint of this route, what lemma it mirrors, or the statement-level
frictions (CommRingCat/forget₂ monoidal-instance pinning via `show … from`; the explicit
`(F := …)` needed to unify δ's pullback against the `pullbackComp` codomain; the `eqToHom` bridge
via finding (1)).

A prover with only the blueprint sketch would not know where the genuine obstacle lies, would not
know to look for `Adjunction.isMonoidal_comp` as the mirror, and could not produce a correct proof
of D3′ from prose alone.

Severity: **must-fix-this-iter** (blueprint adequacy failure — proof sketch misdirects on the hard
step and is silent on the route).

### Excuse-comment style in proof body

`pullbackTensorMap_restrict` has a large (63-line) roadmap comment as its proof body ending in
`sorry`. The roadmap correctly documents the route; this is a **tracked open obligation** consistent
with the project workflow, not an excusing comment. The Lean comment is accurate and honest.

Severity: **informational** — not a red flag, but the comment's Sq2/Sq2b finding (1) is the
ground truth that should update the blueprint.

---

## Unreferenced declarations (informational)

- `toRingCatSheafHom_comp_hom_reconcile` (private) — helper for D3′ Sq2, proved by `rfl`.
  Not `\lean{}`-pinned (acceptable as private helper). Its existence and the `rfl` close
  are the primary iter-257 findings that require blueprint updates.

All other declarations in the `LocTrivPullbackTensor` section are already `\lean{}`-referenced
or are private helpers.

---

## Blueprint adequacy for this file

**Coverage (D3′ focus):**
- `pullbackTensorMap_restrict` → `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` ✓
- `toRingCatSheafHom_comp_hom_reconcile` → private, unreferenced (acceptable)

**Proof-sketch depth (D3′ `lem:pullback_tensor_map_basechange`):** **under-specified** in two
respects:
1. The Sq2 paragraph incorrectly labels the ring-map reconciliation as "non-trivial transport"
   (it is `rfl`).
2. The genuine Sq2b step (monoidality of `pullbackComp` / `comp_δ` transport, mirroring
   `Adjunction.isMonoidal_comp`) is absent from the sketch entirely. The sketch therefore fails
   to identify the actual missing Mathlib ingredient and gives no guidance on the mate-calculus
   route.

**Hint precision:** The `\lean{…}` hint is correct. The proof-body description is wrong at
the Sq2 level.

**Generality:** The statement generality (general composable morphisms, not just open immersions)
is correct and matches the Lean.

**Recommended chapter-side actions (for the blueprint-writing subagent):**

1. **Replace** the Sq2 paragraph's "non-trivial" claim:
   > *"which is non-trivial because... transported by the pseudofunctor coherence. The bookkeeping
   > atoms `{pullbackId, pullback_assoc, ...}` discharge..."*

   with:
   > *"which is DEFINITIONAL (`toRingCatSheafHom_comp_hom_reconcile`, proved by `rfl`): the Scheme
   > composition defeqs make both sides equal on the nose, so `PresheafOfModules.pullbackComp φ'_f φ'_h`
   > lands in `pullback φ'_{h≫f}` without any pseudofunctor-coherence transport. The bookkeeping atoms
   > listed are NOT needed for this sub-step."*

2. **Add Sq2b** as a new sub-step immediately following the reconciliation:
   > *"Sq2b (monoidality of `pullbackComp`): Once the ring-map reconciliation identifies
   > `pullback φ'_{h≫f}` with `pullback φ'_f ⋙ pullback φ'_h`, the Mathlib lemma
   > `Functor.OplaxMonoidal.comp_δ` decomposes `δ` of the composite functor. Transporting this through
   > the iso `PresheafOfModules.pullbackComp` requires showing that `pullbackComp` is compatible with
   > the oplax structure — i.e., the `δ` of the `Adjunction.leftAdjointCompIso`-identified composite
   > matches `comp_δ`. This is Mathlib-absent and must be proved by mate calculus, mirroring
   > `Adjunction.isMonoidal_comp` (Mathlib `Functor.lean:990`). Statement-level friction: the
   > `δ (pullback φ')` goal requires the CommRingCat/forget₂ monoidal-instance pin
   > (`show … from` / `let φ' : … ⋙ forget₂`) from D1′, and the `pullbackComp`-codomain unification
   > needs an explicit `(F := …)` ascription plus an `eqToHom` bridge via the ring-map reconciliation."*

3. **Add** a `% NOTE:` annotation at the top of the D3′ proof block recording the iter-257 findings:
   > `% NOTE: iter-257: ring-map reconciliation (Sq2) is rfl (not non-trivial transport);`
   > `% genuine obstacle is Sq2b (pullbackComp monoidality / comp_delta transport) mirroring`
   > `% Adjunction.isMonoidal_comp. Blueprint sketch updated to reflect this finding.`

---

## Severity summary

| Finding | Severity |
|---------|----------|
| Blueprint Sq2 paragraph claims ring-map reconciliation is "non-trivial transport" — it is `rfl` | **must-fix-this-iter** |
| Blueprint sketch omits Sq2b (genuine blocking step: `pullbackComp` monoidality / `comp_δ` transport, mate-calculus route mirroring `Adjunction.isMonoidal_comp`) | **must-fix-this-iter** |
| `pullbackTensorMap_restrict` body is `sorry` — this is a tracked open obligation; statement block `\leanok` is accurate | informational |
| `toRingCatSheafHom_comp_hom_reconcile` closes by `rfl`, unreferenced in blueprint (private helper) | informational |

**Overall verdict:** The D3′ statement and `\leanok`-marker state are correct; the blueprint
proof sketch for `lem:pullback_tensor_map_basechange` has a must-fix factual error (Sq2
ring-map reconciliation mislabelled "non-trivial") and a must-fix omission (Sq2b, the genuine
Mathlib-absent blocker, is not described at all). 2 declarations checked, 2 must-fix findings
(both blueprint-side).
