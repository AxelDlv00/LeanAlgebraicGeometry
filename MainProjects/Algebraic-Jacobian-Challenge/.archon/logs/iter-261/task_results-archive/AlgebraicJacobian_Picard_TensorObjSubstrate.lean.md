# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Objective (iter-260/261, D3′ residual)
Close `pushforwardComp_lax_μ` — the lone remaining D3′ Sq2b residual ("`pushforwardComp` is
monoidal": the lax tensorator μ of the composite `pushforward ψ ⋙ pushforward φ` equals the μ of
the single `pushforward (φ ≫ F.op ◁ ψ)`). Prepared corrective: `analogies/pushforwardcomp-lax-mu260.md`.

## RESULT: RESOLVED — axiom-clean

- **`pushforwardComp_lax_μ`**: CLOSED, `#axioms = {propext, Classical.choice, Quot.sound}` (no `sorryAx`),
  verified via `lean_verify` on `AlgebraicGeometry.Scheme.Modules.pushforwardComp_lax_μ`.
- **`pullbackComp_δ`** (its consumer, the Sq2b mate calculus): now also axiom-clean (same axiom set).
- File compiles `EXIT 0`. Only edited this file (`PresheafInternalHom.lean` etc. untouched — confirmed
  by `git diff --stat`).

## Key insight (the discovery that unlocked it)
The analogist's "~150-LOC `extendScalarsComp` build" estimate (and the lemma's old docstring) were
**wrong**. The proof is a sectionwise pure-tensor collapse. Two foundational `rfl`-lemmas:

1. **`pushforward_μ_eq`** (`rfl`): `μ (pushforward φ) A B = μ (restrictScalars φ') (P₀.obj A) (P₀.obj B)`
   where `P₀ = pushforward₀OfCommRingCat F R₀`. This was the breakthrough — the pushforward μ
   reduces *definitionally* to the lighter `restrictScalars` μ (because `pushforward₀`'s μIso = refl).
2. **`restrictScalars_μ_app`** (`rfl`, under `set_option backward.isDefEq.respectTransparency false`):
   `(μ (restrictScalars α) M₁ M₂).app W = μ (ModuleCat.restrictScalars (α.app W).hom) (M₁.obj W) (M₂.obj W)`.

Then on a pure tensor every `restrictScalars` μ is the identity (`ModuleCat.restrictScalars_μ_tmul`),
so both sides collapse to `m ⊗ₜ n`.

## Proof skeleton (now in the file)
```
refine PresheafOfModules.hom_ext (fun W => ?_)         -- section level
refine ModuleCat.MonoidalCategory.tensor_ext (fun m n => ?_)  -- pure tensor (avoids zero/add cases)
rw [Functor.LaxMonoidal.comp_μ]                         -- unfold composite μ
rw [pushforward_μ_eq, pushforward_μ_eq]                 -- pushforward μ → restrictScalars μ
rw [PresheafOfModules.comp_app]
erw [ModuleCat.hom_comp, LinearMap.comp_apply]          -- split composite hom application
rw [restrictScalars_μ_app (R := S₀) (S := F.op ⋙ R₀)]  -- inner leg → ModuleCat μ (pin functors!)
erw [hinner]   -- forget₂_restrictScalars_μ_hom_tmul on the inner leg → m ⊗ₜ n
erw [houter]   -- pushforward_map_restrictScalars_μ_app_tmul on the (pushforward φ).map leg → closes
```

## Helper lemmas added (all `private`, axiom-clean)
- `pushforward_μ_eq`, `restrictScalars_μ_app` (mine, the two `rfl` foundations).
- `forget₂_restrictScalars_μ_hom_tmul`, `restrictScalars_μ_app_tmul`,
  `pushforward_map_restrictScalars_μ_app_tmul`, `pushforward_map_app_apply` (added by the deep-prover
  subagent to discharge the two element-level legs).

## Dead ends / gotchas (record for next time)
- **whnf explosion**: a DIRECT `rw`/`erw`/`simp [ModuleCat.restrictScalars_μ_tmul]` on these goals
  times out (>200000 heartbeats, even at 2M) because the `pushforward₀` section objects are huge. The
  ONLY robust pattern: instantiate an atom-stated helper with the goal's concrete heavy objects as
  EXPLICIT arguments into a `have`, then `erw [that_have]` — `erw` matches only the residual defeq
  (instance / `forget₂`-association) and never `whnf`-s the heavy objects.
- **HO-match flakiness**: `rw [restrictScalars_μ_app]` silently no-matches because the goal carries `φ`
  at the *inner* association `F.op ⋙ (R₀ ⋙ forget₂)` while the lemma needs the *outer*
  `(F.op ⋙ R₀) ⋙ forget₂`. Fix: pin implicits `(R := S₀) (S := F.op ⋙ R₀)`.
- **morphism-level helper won't typecheck**: `(presheaf-tensor).obj W` is NOT defeq to the `ModuleCat`
  tensor of the `.obj W`s, so a clean morphism-equality `μ (pushforward φ).app W = ModuleCat μ` fails
  to elaborate (even with `eqToHom (by rfl)`). Must stay at `PresheafOfModules` morphism level
  (`pushforward_μ_eq`) or go fully element-level.
- **`tensor_ext` beats `induction x`**: `ModuleCat.MonoidalCategory.tensor_ext (fun m n => ?_)` after
  `hom_ext` gives ONLY the pure-tensor case (no zero/add coe wrangling, which `map_zero`/`map_add`
  failed to fire on here).

## Blueprint
`pushforwardComp_lax_μ` / `pullbackComp_δ` are ready for `\leanok` (handled by the deterministic
`sync_leanok` pass). The chapter `Picard_TensorObjSubstrate.tex`'s Sq2b prose should be updated by the
plan/review agents to drop the "rfl-false ⇒ ~150-LOC change-of-rings build" framing — the actual proof
is the much shorter sectionwise pure-tensor collapse above (the genuine content is just
`ModuleCat.restrictScalars_μ_tmul`).

## Out of scope (untouched, still `sorry`)
- `exists_tensorObj_inverse` (~L693) — RPF group-inverse, consumes the dual chain.
- `pullbackTensorMap_restrict` (~L2449) — the *outer* D3′ lemma; needs the separate Sq1/Sq4
  composition sub-lemmas (not the μ-coherence residual that was this iter's target).
