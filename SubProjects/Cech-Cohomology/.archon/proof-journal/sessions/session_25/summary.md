# Session 25 (iter-025) — review summary

## Metadata
- **Session / iter**: 25 / iter-025
- **Lanes planned / ran**: 1 / 1 (CechBridge.lean — single-file prover lane)
- **Sorry count**: 2 → 2 (no change). Both intentional/frozen:
  - `CechHigherDirectImage.lean:679` (frozen P5b `cech_computes_higherDirectImage`)
  - `CechAcyclic.lean:110` (superseded relative-form `CechAcyclic.affine`, blueprint-authorized)
- **Build**: GREEN. `lake env lean CechBridge.lean → EXIT 0`, file diagnostic-clean.
- **+1 axiom-clean named target landed**: `AlgebraicGeometry.injective_cech_acyclic`
  (`{propext, Classical.choice, Quot.sound}`, confirmed via `lean_verify`).
- **unmatched** (`archon dag-query unmatched`) = 0; **gaps** (∞ holes) = 0.
- **Blueprint doctor**: no structural findings (no orphan chapters, no broken refs, no new axioms).

## Target: `AlgebraicGeometry.injective_cech_acyclic` — SOLVED

The final P3b bridge target: positive-degree Čech-vanishing for injective sheaves,
```
theorem injective_cech_acyclic (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (I : X.Modules) [Injective I]
    (p : ℕ) (hp : 0 < p) :
    IsZero ((sectionCechComplex (coverOpen 𝒰)
      ((Scheme.Modules.toPresheafOfModules X).obj I)).homology p)
```
This is the `Ȟᵖ(𝒰, I) = 0` (p>0) half of Stacks `lemma-injective-trivial-cech`, in the
`IsZero` homology form the 01EO consumer (`cech_to_cohomology_on_basis`) needs. The
`Ȟ⁰ = I(U)` clause is the separate easy degree-0 fact, deliberately NOT in this declaration.

### Proof structure (the one-step op-transport assembly, landed first try, exactly as planned)
1. `haveI : QuasiIso (cechFreeComplexAug 𝒰) := cechFreeComplex_quasiIso 𝒰` (Lane 1, iter-024).
2. `haveI : Injective (toPresheafOfModules.obj I) := injective_toPresheafOfModules I` (Part 1).
3. `ψ := (preadditiveYoneda.obj F).mapHomologicalComplex ((down ℕ).symm)` applied to
   `(opFunctor _ (down ℕ)).map (cechFreeComplexAug 𝒰).op`, kept `QuasiIso` by
   `quasiIso_map_preadditiveYoneda_of_injective`.
4. `Θ := ψ ≫ (sectionCechComplexMapOpIso 𝒰 F).hom` — `QuasiIso` by `inferInstance`.
5. Source complex (`Hom(-, I)` of op of degree-0-concentrated `single₀.obj O_𝒰`) has a
   **zero object** at every degree `n+1` (`Functor.map_isZero` of
   `HomologicalComplex.isZero_single_obj_X`), hence zero homology there.
6. Transfer along the quasi-iso: `hsrcZero.of_iso (asIso (homologyMap Θ (n+1))).symm`.

### Key Lean lessons (see attempts in milestones.jsonl)
- `QuasiIso` of an opped morphism is an **automatic instance** given `[QuasiIso f]`;
  composing a quasi-iso with an iso preserves it via `inferInstance`.
- `ChainComplex.single₀` is **reducibly** `HomologicalComplex.single _ (down ℕ) 0`, so
  `HomologicalComplex.isZero_single_obj_X (down ℕ) 0 _ (n+1) (Nat.succ_ne_zero n)` applies
  directly. The `single₀_obj_X_succ` / `OfNat C 0` detours were dead ends.
- `set_option maxHeartbeats 2000000 in` is **legitimately required** (default 200000 is
  exceeded by the nested `opFunctor`/`mapHomologicalComplex`/`(down ℕ).symm` defeq coercions).
  lean-auditor confirmed the bump is justified, not masking a fragile proof.

## Secondary work
- The prover fixed the 2 stale module-docstring header bullets flagged by lean-auditor
  iter-024 (`ses_cech_h1` no longer "(planned)", `injective_cech_acyclic` no longer "gated").
  **However** lean-auditor iter-025 found 3 MORE stale comments still live in the file
  (see recommendations) — the stale-comment debt is reduced but not cleared.

## HEADLINE ANOMALY — spurious `\leanok` removal by sync_leanok
`sync_leanok-state.json` for iter-025: **removed 6, added 0**, chapter
`Cohomology_CechHigherDirectImage.tex`. The two most-recently-landed bridge targets now
**lack `\leanok`** despite being axiom-clean and compiling:
- `lem:injective_cech_acyclic` (this iter's target) — never received `\leanok`.
- `lem:ses_cech_h1` (landed iter-024, **had** `\leanok` after iter-024) — `\leanok` was REMOVED.

I verified both directly: `lean_verify` → `{propext, Classical.choice, Quot.sound}` for both,
and `lake env lean CechBridge.lean → EXIT 0`. The proofs are genuinely sound. The marker
removal is **not** a laundering signal — it is a sync_leanok mis-verdict, most plausibly a
build timeout during the sync window (CechBridge's heaviest decl needs `maxHeartbeats
2000000`; if sync builds under a lower budget the decl reads as non-compiling, and the
consolidated chapter's CechBridge-/FreePresheafComplex-backed markers get stripped).
lean-vs-blueprint-checker independently flagged the same 4-block `\leanok` gap.
**I did NOT touch `\leanok`** (not my domain). Flagged for the planner in recommendations.

## Subagent reports (this iter)
- `lean-vs-blueprint-checker` (cechbridge): **PASS, 0 must-fix.** 13 decls checked, 0 red flags.
  `injective_cech_acyclic` + `ses_cech_h1` faithful & axiom-clean. 1 major (blueprint p=0 gap
  annotation — **applied** by me as `% NOTE:`) + 2 minor.
  → `.archon/task_results/lean-vs-blueprint-checker-cechbridge.md`
- `lean-auditor` (iter025): **0 must-fix**, file proof-correct & axiom-clean. 3 major (all stale
  `.lean` comments — review can't edit, queued) + 1 minor (uncommented `maxHeartbeats` on
  `ses_cech_h1`). → `.archon/task_results/lean-auditor-iter025.md`

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:injective_cech_acyclic`: added `% NOTE:`
  recording that only the p>0 vanishing clause is formalized (the `Ȟ⁰ = I(U)` clause is not).

## Notes (LOW)
- lean-auditor minor: `set_option maxHeartbeats 1600000 in` on `ses_cech_h1` (line 637) lacks
  the explanatory inline comment that the analogous bump at line 851 has.

## Recommendations for next session
See `recommendations.md`. Headline: (1) re-run / investigate sync_leanok so the 4 axiom-clean
blocks regain `\leanok`; (2) next frontier is `def:absolute_cohomology` → 01EO → 02KG to
re-enable the frozen P5b; (3) queue the 3 stale-comment fixes next time a prover opens CechBridge.
