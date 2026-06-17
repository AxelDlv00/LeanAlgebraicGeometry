# Session 15 (iter-015) — Review Summary

## Metadata
- **Iteration / session**: iter-015 / session_15
- **Prover lanes**: 2 parallel `mathlib-build` lanes (P3 `CechAcyclic.lean`, P3b `PresheafCech.lean`).
  Both lanes ran to completion this iter — the iter-011 weekly-API-limit abort did NOT recur.
- **Files edited**: `AlgebraicJacobian/Cohomology/CechAcyclic.lean`,
  `AlgebraicJacobian/Cohomology/PresheafCech.lean`.
- **Sorry count**:
  - `CechAcyclic.lean`: 1 → 1 (target `CechAcyclic.affine` L74 still open; **no new sorry** — 9 new
    helpers all closed; the second `sorry` token grep-matches is inside the explanatory comment).
  - `PresheafCech.lean`: 0 → 0 (build-new lane; 2 declarations added, neither with a sorry).
- **Net**: +11 new axiom-clean declarations, 0 new sorries, target `CechAcyclic.affine` still PARTIAL.
- **Axioms**: every new declaration verified `{propext, Classical.choice, Quot.sound}` via `lean_verify`.
- **Build**: both files compile clean (CechAcyclic: only the expected L74 sorry warning; PresheafCech:
  0 errors / 0 warnings).

## Target 1 — `CechAcyclic.affine` (P3 lane) — PARTIAL, the iter-011 blocker (L3) is now CLEARED

**Planner factoring** (`analogies/p3-localisation.md`): P3 = L1 (geometry↔algebra bridge) → L2
(`exact_of_isLocalized_span`, Mathlib) → L3 (explicit contracting homotopy). The iter-011 prover
died mid-search for L3 while (wrongly) drifting toward `SimplicialObject.Augmented.ExtraDegeneracy`.

**What was built (L3, axiom-clean, `private` namespace `AlgebraicGeometry.CombinatorialCech`, L127–238):**
- `combDifferential t σ = ∑ⱼ (-1)ʲ • t (σ ∘ j.succAbove)` — alternating coface (Čech) differential
  on `Cⁿ = (Fin n → ι) → M`, `[AddCommGroup M]`.
- `combHomotopy r u τ = u (Fin.cons r τ)` — prepend the fixed index `r`.
- `combHomotopy_spec : d∘h + h∘d = id` — split `h(d t)` at `j=0` via `Fin.sum_univ_succ` (gives `t`),
  the rest cancel against `d(h t)` termwise by `cons_comp_succAbove_succ` + sign flip.
- `combDifferential_comp : d² = 0` — sign-reversing involution `(j,i) ↦ (j.succAbove i, i.predAbove j)`
  on the double sum via `Finset.sum_involution`
  (`Fin.succAbove_succAbove_succAbove_predAbove`, `Fin.succAbove_succAbove_predAbove`,
  `Fin.predAbove_predAbove_succAbove`, `Fin.succAbove_ne`, `combSign_flip`).
- `combDifferential_exact r n : Function.Exact (d) (d)` (positive degree) — ker⊆im from the homotopy,
  im⊆ker from `d²=0`; the exact shape `exact_of_isLocalized_span` consumes node by node.

**Why the target sorry is retained — precise blocker:** `CechComplex f 𝒰 F` is the *abstract*
categorical complex `relativeCechComplexOfNerve f (CechNerve 𝒰 F)` = `alternatingCofaceMapComplex`
of the pushforward of `cechNerveCosimplicial` (`CechHigherDirectImage.lean:712,737`). To apply L2/L3
one must first construct **L1**: identify the degree-`p` term `(CechComplex …).X p` with the concrete
module product `∏_{σ:Fin(p+1)→ι} M_{s_σ}` of away-localisations and its differential with the
alternating localisation-restriction coboundary (a multi-step `Scheme.Modules` computation:
`pushPullObj`, `Scheme.Modules.pushforward`, `evaluation`, and
`IsAffineOpen.isLocalization_of_eq_basicOpen`). Additionally the localised complex has **varying**
coefficients `M_{s_σ s_r}`, so L3 needs a dependent-coefficient port with a prepend-iso
`A (Fin.cons r τ) ≃ A τ` (valid because `s_r` is a unit after localising at `s_r`); the constant
version built here is the cancellation/sign skeleton that ports verbatim modulo threading `ρ`.

**Dead end (do NOT retry):** routing L3 through `SimplicialObject.Augmented.ExtraDegeneracy` /
`extraDegeneracyCech` — wrong variance (chain vs cochain), no cosimplicial dual in Mathlib
(confirmed `analogies/p3-localisation.md` b3). The explicit module homotopy is the replacement.
Also: `Fin.val_castPred` does **not** exist — use `Fin.coe_castPred`.

## Target 2 — `PresheafCech.lean` (P3b lane) — 2 of ~5 planned bricks landed

### `injective_toPresheafOfModules` — SOLVED (Part 1 of `lem:injective_cech_acyclic`)
`(I : X.Modules) [Injective I] : Injective ((Scheme.Modules.toPresheafOfModules X).obj I)`, via
`Injective.injective_of_adjoint` fed the sheafification adjunction. Right adjoint
`SheafOfModules.forget ⋙ restrictScalars (𝟙 _) = toPresheafOfModules X` (by `rfl`); left adjoint
`sheafification (𝟙 _)` has a Mathlib `PreservesMonomorphisms` instance.
- **Gotcha (recorded as a reusable pattern):** the one-liner term form times out at typeclass
  synthesis — `X.Modules` vs `SheafOfModules X.ringCatSheaf` are defeq but not syntactically the same
  category instance. Fix: `haveI : Injective (C := SheafOfModules X.ringCatSheaf) I := ‹Injective I›`
  (must be `C :=`, not `X :=`). With that, no `maxHeartbeats` bump needed.

### `freeYonedaHomEquiv` — SOLVED (per-term core of `lem:cech_complex_hom_identification`)
`Hom(free(yoneda V), F) ≃ F(V)` as `PresheafOfModules.freeHomEquiv.trans yonedaEquiv`.
- **Limitation:** a bare `Equiv` of hom-sets only — NOT additive/`R`-linear, no naturality in `F`. To
  assemble the cochain-complex iso it must become an `AddEquiv` natural in `F`, compatible with the
  alternating differential. Verified per-term core, not the finished identification.

### Blocked (recipes written, nothing shippable without `sorry` on functor/complex laws)
- `sectionCechComplex` — needs `CosimplicialObject` (`SimplexCategory ⥤ C`) with `map_id`/`map_comp`
  (reindexing+restriction over tuples, ~50–150 LOC), then `alternatingCofaceMapComplex` (gives `d²=0`
  for free). **Dead end:** don't derive it from the Čech nerve in `Opens X` — the poset's fibre
  products degenerate and lose the index `ι`; the `∏_{Fin(p+1)→ι}` must be explicit.
- `cechFreePresheafComplex` — `ChainComplex` of free presheaves; build via simplicial object +
  `AlternatingFaceMapComplex` (don't hand-roll `d²=0`, don't use `ExtraDegeneracy`).
- full `cechComplex_hom_identification` iso + `cechFreeComplex_quasiIso` — chained behind the above +
  the additive upgrade. Mathlib has **no** packaged `biproduct.homEquiv`/`Sigma.homEquiv` (all of
  `biproduct.homEquiv`, `Sigma.homEquiv`, `Cofan.IsColimit.homEquiv`, `coproductHomEquiv` confirmed
  UNKNOWN) — assemble from `Sigma.ι`/`Sigma.desc` + `Sigma.ι_desc`.

## Coverage debt (1-to-1 Lean↔blueprint) — 11 unmatched `lean_aux` nodes
`archon dag-query unmatched` lists **11** declarations with no blueprint block. The CechAcyclic
task_result predicted its `private` helpers would NOT appear in `unmatched` — that prediction is
**wrong**: private declarations still register as `lean_aux` nodes. All 11 are listed in
`recommendations.md` with their suggested bundling targets for the planner to wire next iter.

## Subagent reviews (this phase)
- **lean-auditor** (`iter015`): SOUND — 6 files, **0 must-fix / 0 excuse-comments**, 3 major (stale
  status comments — see recommendations), 4 minor. The `CechAcyclic.affine` comment block judged an
  *honest scope note*, not an excuse-comment. Report:
  `.archon/logs/iter-015/lean-auditor-iter015-report.md`.
- **lean-vs-blueprint-checker** (`cechacyclic`): signature LSP-verified to match
  `lem:cech_acyclic_affine`; `CombinatorialCech` axiom-clean and faithful to the L3 sketch. Two
  **major** blueprint-adequacy gaps: (1) bundle the 9 helpers into `lem:cech_acyclic_affine`'s
  `\lean{}` list; (2) the chapter proof sketch is **silent on L1** — a prover cannot start L1 from
  prose alone. Report: `.archon/logs/iter-015/lean-vs-blueprint-checker-cechacyclic-report.md`.
- **lean-vs-blueprint-checker** (`presheafcech`): clean — both helpers match the prose; blueprint
  adequate. Report: `.archon/logs/iter-015/lean-vs-blueprint-checker-presheafcech-report.md`.

## Blueprint structural health
- **blueprint-doctor** (iter-015): no findings — every chapter `\input`'d, every `\ref`/`\uses`
  resolves, no `axiom` declarations.
- **sync_leanok** (iter-015, sha d4bec48): added 0, **removed 8** `\leanok` across
  `Cohomology_AcyclicResolution.tex` and `Cohomology_CechHigherDirectImage.tex`. iter==15 matches
  current, so these removals are the deterministic script's verdict, not laundering — 8 blocks
  previously marked done no longer have a sorry-free formalized Lean target (expected fallout of the
  file split / reconstruction; surfaced here for the planner, not flagged as a regression to chase).

## Blueprint markers updated (manual)
- None. No `\mathlibok` warranted (the 2 new public decls are project proofs that *use* Mathlib, not
  re-exports/aliases). No `\notready` present to strip. No prover rename to correct. The 11 unmatched
  helpers are deferred to the planner per Step 6 (review agent does not author blueprint entries).

## Minor notes (LOW, from lean-auditor)
- One cosmetic type ascription in `combHomotopy_zero`; one category-realignment `haveI` in PresheafCech
  (the intended fix above); two high `maxHeartbeats` options left on now-fast proofs (could be trimmed).
