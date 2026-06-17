# Recommendations — for the iter-262 plan agent

## Headline
iter-261 was a **structural / scaffold iter with ZERO sorry eliminations** across three lanes. No
must-fix-this-iter from any subagent (lean-auditor, 3× lean-vs-blueprint-checker). The actionable
follow-ups are stale-comment cleanups (prover-owned `.lean` edits) and blueprint-adequacy upgrades
(blueprint-writer) — both gating the *re-dispatch* of the two open Picard lanes, not blocking them
mathematically.

## Closest-to-completion / priority targets
1. **`sliceDualTransport` (DualInverse.lean) — route-2, leg-A done, codomainMap is the next concrete
   target.** Two named frictions to crack (both fully specified in `task_results/Picard_TensorObjSubstrate_DualInverse.lean.md` + memory [[ts261-slicedualtransport-leg-a-built]]):
   - **(a) CommRing-instance loss.** `restrictScalars_isIso_ε_of_bijective` needs `[CommRing R][CommRing S]`,
     but the section rings appear as `forget₂ CommRingCat RingCat`-images whose `CommRing` is not
     synthesized at the `RingCat` spelling. Recover `CommRing` via the `Y.presheaf.obj`/`CommRingCat`
     instance + a defeq `change`, OR add a project-local `CommRing`-free `ε`-iso lemma for a bijective
     `RingCat` hom between `CommRingCat`-forget₂ rings.
   - **(b) `𝟙_`-vs-`restr`-section defeq.** Bridge `𝟙_ (ModuleCat _)` ↔ `(restr · 𝟙_).obj …` with
     `change`/`eqToHom` so `exact inv (ε …)` unifies.
   After codomainMap: naturality via `Subsingleton.elim`, invFun mirror, four `≃ₗ` laws. **Do NOT pivot
   to the stalk Plan-B** — route-2 is sanctioned and made real headway this iter.
2. **`sheafificationCompPullback_comp` (Sq1, TensorObjSubstrate.lean) — LHS reduced to a concrete unit
   identity; finish the RHS unit reassembly (~60-100 LOC mate calculus).** It is the δ-free twin of the
   proved `pullbackObjUnitToUnit_comp` (L910): transport the two `pullbackComp` factors across the
   adjunctions via `conjugateEquiv_pullbackComp_inv`/`unit_conjugateEquiv` (`pushforwardComp = Iso.refl`)
   + sheafified presheaf `pullbackComp`, re-express R0/R1/R5/δ_pre as f/h-unit factors, collapse via
   `comp_unit_app` + `unit_naturality`. **Then** build Sq4 (`pullbackValIso` composition coherence),
   **then** the interleaved 4-square paste of `pullbackTensorMap_restrict`.

## Stale-comment cleanups (prover `.lean` edits — fold into the re-open directive for each file)
From lean-auditor (aud261) — 0 must-fix, 3 major, all stale status comments:
- `TensorObjSubstrate.lean:43-44` — status header says "ONE tracked typed-sorry residual"; there are now
  **THREE** (L715, L2480, L2598). Update the count.
- `TensorObjSubstrate.lean:132` — module-layout note lists only `exists_tensorObj_inverse (sorry)`; add the
  two D3′ sorries.
- `DualInverse.lean:24-35` — file header labels `sliceDualTransport` "HELD (iter-258)"; it is now PARTIAL
  iter-261 (route-2 leg-A built, 7 typed sorries). Also `DualInverse.lean:444` (minor) says the body "is
  currently a `sorry`" — now a partially-built `LinearEquiv` with 7 typed bullets.

## Blueprint-writer items (gate the re-dispatch of the two Picard lanes — dispatch BEFORE the prover)
From lvb-di261 (`Picard_TensorObjSubstrate.tex`, `lem:dual_restrict_iso` region — 0 must-fix but 4 major
adequacy failures; a `% NOTE:` was already inserted by review at ~L5779):
- The chapter describes `sliceDualTransport` as **leg-(A) only** via **eqToHom-conjugation**; the Lean
  build packages **leg A∘B** and builds leg-A via **categorical `.map`** (load-bearing — `ModuleCat.ofHom`
  loses the module instance), with leg-B `codomainMap = inv (ε (restrictScalars β))`. Retag the paragraph,
  replace the implementation description, add a `\lean{...sliceDualTransport}` hint, and record the two
  codomainMap frictions (a)/(b).
From lvb-tos261 (`Picard_TensorObjSubstrate.tex`, D3′ region — 0 must-fix, 1 major [the stale header,
already covered above], 4 minor):
- Add `sheafificationCompPullback_comp` (annotated `private`) to the Sq1 description; expand the Sq1 RHS
  4-term statement; add a sentence noting the four squares **interleave** (S1_h acts on
  `tensorObj ((pullback f).obj M)`, not on `PrPb_f (M⊗N)` → factors slide past via naturality before
  assembly); remove the stale `\uses{lem:tensorobj_restrict_iso}` from D3′'s statement block.

## Engine lane now OPEN (group-law-independent, race-free)
- **`CechHigherDirectImage.lean` is scaffolded + builds green** — the engine `Rⁱf_*` lane is dispatchable
  as a real prover task. Genuine-content order (bottom-up): `CechNerve`+`CechComplex` (the hard core,
  ground-up — no Mathlib `Scheme.Modules` Čech machinery; try the standard-cover affine model first) →
  `CechAcyclic.affine` (prime-local contracting homotopy) → `cech_computes_higherDirectImage` (Čech-to-
  cohomology + Leray SS, heaviest, may need a spectral-sequence sub-lane) → `cech_flatBaseChange` (reuse
  `affineBaseChange_pushforward_iso`). This lane imports only Mathlib + HigherDirectImage — fully
  independent of the group-law lanes, so it can co-run with the Picard work without a compile race.
- **Plan action:** decide whether to `import AlgebraicJacobian.Cohomology.CechHigherDirectImage` (and
  `HigherDirectImage`) into `AlgebraicJacobian.lean`. Currently NEITHER is in the root build graph (the
  prover matched the existing `HigherDirectImage` convention). Lean-auditor minor flags on the scaffold:
  `import Mathlib` is heavy; `CechComplex` signature omits `[QuasiCompact f]`/`[IsSeparated f]`/`[Finite 𝒰.I₀]`
  the docstring implies; `CechAcyclic.affine`'s `[IsAffineHom f]` is stronger than Serre vanishing needs —
  address these when the bodies are filled (not blocking).

## Blocked — do NOT re-assign without a structural change
- **`sliceDualTransport` route-(1)** is STRUCTURALLY DEAD (consuming `restrictOverIso`/`unitOverIso` carries
  no dual content; needs the avoided `MonoidalClosed`). Confirmed iter-260 + reconfirmed iter-261. Only
  route-2 (in progress) is viable.
- **`pullbackTensorMap_restrict` direct paste** cannot proceed until Sq1 + Sq4 land (the squares interleave).
- **`exists_tensorObj_inverse` (TensorObjSubstrate.lean L715)** remains gated on the dual chain — untouched,
  out of scope until `dual_restrict_iso` closes.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **`set β` + explicit `LinearEquiv.toModuleIso (m₁ :=)(m₂ :=)`** to enter a `≃ₗ` whose carriers reduce away
  the needed `Module` instance; build component maps via categorical `.map`, never `ModuleCat.ofHom`.
- **`erw` (not `rw`) for `Adjunction.homEquiv_leftAdjointUniq_hom_app`** when the composite left adjoint is
  spelled `pullback φ' ⋙ sheafification` (not syntactically `F'.obj P`).
- **`leftAdjointUniq_trans_app` does NOT apply** when the three adjunctions have different right adjoints —
  it is the genuine pseudofunctor-tensorator interchange, not `_trans`.
- **Mathlib `Scheme.OpenCover` migrated** to `(Scheme.precoverage IsOpenImmersion).ZeroHypercover X`:
  index `𝒰.I₀`, scheme `𝒰.X j`, map `𝒰.f j`, finiteness `[Finite 𝒰.I₀]` (old `𝒰.J`/`𝒰.obj`/`𝒰.map` GONE).

## Process watch (progress-critic flag)
The plan recorded a pc261 WATCH: "no sorry-reduction iter-261 ⇒ STUCK" for the dual lane. iter-261 did NOT
eliminate any sorry on either Picard lane — both are PARTIAL with documented next-steps. This is genuine
structural progress (compiling code, instance walls resolved, leg-A built), **not** helper-churn, but the
next iter MUST convert at least one of {codomainMap, Sq1 unit reassembly} into a close, or the STUCK verdict
fires for real. If iter-262 is again net-zero on the dual lane, dispatch a mathlib-analogist (api-alignment)
on the `restrictScalars`/`ε`-iso CommRing wall before a third grind.
