# Mathlib Analogist Report

## Mode
api-alignment

## Slug
mapin255

## Iteration
255

## Question
`pullbackTensorMap_natural` (D1′, TensorObjSubstrate.lean ~L2004) is blocked: after
`simp only [pullbackTensorMap]`, `Functor.OplaxMonoidal.δ_natural (F := PresheafOfModules.pullback φ')`
fails with `failed to synthesize MonoidalCategory (PresheafOfModules X.ringCatSheaf.obj)` because the
monoidal instance is registered only on `X.presheaf ⋙ forget₂ CommRingCat RingCat`
(`Presheaf/Monoidal.lean:32,104-105`), defeq-but-not-syntactic to `X.ringCatSheaf.obj`. Rank fixes
(A) light proof-side / (B) medium def retype / (C) heavy restatement; give the recipe; state whether
D2′ (`pullbackTensorMap_unit_isIso`, L1848) is at risk; say whether one PROVER lane can do it.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| How to spell `F` so `δ_natural`'s domain `MonoidalCategory` synthesizes | PROCEED via option (A) | informational |
| Source-level `ringCatSheaf.obj`-vs-`⋙ forget₂` spelling cleanup | DIVERGE_INTENTIONALLY (defer) | informational |

## Ranked verdict

**(A) LIGHT — proof-side normalisation. WINS. Verified live this iter.** A single `erw` with a
`show … from …`-ascribed `F` clears the instance synthesis and performs the blocked δ-commutation.
No definition change; D2′ untouched; one PROVER lane executes it this iter.

**(B) MEDIUM — not needed** (would extract `φ'` to a named private def so it survives `simp` zeta —
correct but heavier than (A), and a def-body touch that forces re-verifying D2′ + IsIso consumers).

**(C) HEAVY — not needed** (full restatement on `⋙ forget₂`; ~80–150 LOC, risks D2′ and IsIso consumers).

## The fix (option A)

Replace the `sorry` at L2064 with:

```lean
erw [← Functor.OplaxMonoidal.δ_natural
  (F := PresheafOfModules.pullback
    (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
      from (Hom.toRingCatSheafHom f).hom))
  a.val b.val]
```

**Verified with `lean_multi_attempt` at L2064 (iter-255):**
- The term `δ_natural (F := pullback (show <canonical> from (Hom.toRingCatSheafHom f).hom)) a.val b.val`
  **elaborates** — the `show … from` ascription forces `pullback`'s domain to
  `PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)`, so the registered monoidal instance
  synthesizes. **The instance hurdle is gone.**
- `erw` (not `rw`) is required: the ascription pretty-prints as `have this := …; this`, so plain `rw`
  misses the syntactic pattern, but `erw`'s reducible-defeq match bridges the zeta gap and fires.
- After the `erw` the goal's `δ` moves `M'.val N'.val ⇝ M.val N.val` with the
  `(Fp.map a.val ⊗ₘ Fp.map b.val)` factor produced — exactly Square 2 (δ-commutation) done.

**This refutes the iter-254 prover's claim** that "there is no place to inject the instance into
`δ_natural`'s domain-ring argument, so a structural spelling-pin refactor is required." The injection
point is the `F :=` argument itself: spelling `F`'s defining ring-hom canonically (via `show … from`)
sets the domain-category instance-search key to the canonical form. No `(C := …)` slot is needed — the
STEP-A `(C := …)` device indeed does not transfer (correct), but a different and simpler device does.

## Blast radius / D2′ risk
**Zero.** Option (A) is entirely inside `pullbackTensorMap_natural`. No `def` is edited, so
`pullbackTensorMap_unit_isIso` (D2′, L1848) and all helper isos are unchanged and stay green.

## Single-lane?
**Yes.** No separate refactor. After the `erw`, the residual is assembling Square 3
(`sheafifyTensorUnitIso_hom_natural`, CLOSED) and Square 4 (`pullbackValIso_hom_natural`, CLOSED) +
`tensorHom_comp_tensorHom`. The only friction is the cosmetic `have this := …; this` wrapper the `erw`
leaves behind — defeq to the bare hom, dischargeable with `show`/`change`/`dsimp only []` as the
surrounding steps already do. A prover lane on this file can finish D1′ this iter.

## Informational
- **Why `simp only [pullbackTensorMap]` triggers this**: the def's `let φ'` (L1214-1215) IS canonically
  ascribed, but `simp` zeta-reduces it to the bare `(Hom.toRingCatSheafHom f).hom`, dropping the
  ascription and re-exposing the `ringCatSheaf.obj` source. Option (A) re-establishes the ascription
  exactly where `δ_natural` needs it.
- **Source-level cleanup (api-alignment angle)**: Mathlib works uniformly in the `⋙ forget₂` spelling
  and has no `.obj`-of-`Sheaf` monoidal API; the project's `Hom.toRingCatSheafHom` leaking the
  `ringCatSheaf.obj` spelling is a mild parallel-presentation that keeps forcing canonical
  re-presentation. A full option-(C) restatement would remove it permanently but is not justified now —
  the `show … from` device is itself the idiomatic minimal re-presentation. DEFER.

## Persistent file
- `analogies/mapin255.md` — recipe + rationale captured for future iters.

Overall verdict: **option (A) — a one-line `erw [← δ_natural (F := pullback (show ⋙forget₂-canonical from (Hom.toRingCatSheafHom f).hom)) a.val b.val]` — clears the instance wall and performs Square 2; verified live, D2′ unaffected, executable by one prover lane this iter.**
