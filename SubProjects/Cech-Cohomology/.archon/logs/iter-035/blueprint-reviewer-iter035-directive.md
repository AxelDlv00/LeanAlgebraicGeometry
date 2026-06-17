# Blueprint-reviewer directive — iter-035

Audit the WHOLE blueprint as usual. The chapters feeding live prover/refactor lanes THIS iter are all in the
consolidated chapter `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`:

1. **02KG cover-system Cov correctness** — `def:affine_cover_system` (around L3714–3755) and
   `lem:affine_surj_of_vanishing` (around L3419+). Context: the iter-034 lean-auditor found the *Lean*
   `affineCoverSystem.Cov` is built WITHOUT the covering condition `⨆ᵢ D(gᵢ) = D(f)`, making
   `HasVanishingHigherCech` over it false for quasi-coherent sheaves (counterexample {D(x),D(y)} on
   Spec k[x,y], Ȟ¹(O)≠0). This iter a refactor tightens the LEAN to add the covering condition and re-signs
   `affine_surj_of_vanishing` so its `hvanish` hypothesis is quantified only over covering families
   (threading the covering witness `D(f)=⨆D(gᵢ)` that `standard_cover_cofinal` already produces). VERIFY the
   blueprint prose for both blocks already (correctly) describes Cov as "standard open covers (finite
   coverings of a distinguished open by distinguished opens)" and that `lem:affine_surj_of_vanishing`'s prose
   is consistent with a covering-only `hvanish`. Flag any prose that still implies the over-broad (all
   finite families) reading. The iter-034 MUST-FIX `% NOTE` on `def:affine_cover_system` documents the fix.

2. **01I8 P3 tilde-kernels** — `lem:tilde_preserves_kernels` (around L4327+). Two new Lean helpers landed
   iter-034 (`tilde_stalkFunctor_map_toStalk`, `tildePreservesFiniteLimits_of_toPresheaf`) that the planner is
   bundling into this lemma's `\lean{}`. Check the proof sketch is detailed enough to guide the REMAINING
   build (R-linearity of the Ab stalk map σ_x + jointly-reflecting stalk-family assembly), and report any
   missing sub-steps the next prover needs.

3. **01I8 P1a restriction chain** — `lem:modules_restrict_basicOpen`, `lem:tilde_restrict_basicOpen`,
   `lem:presentation_restrict_basicOpen`, `lem:isQuasicoherent_restrict_basicOpen` (around L4012–4160).
   These were decomposed by an effort-breaker iter-034 and have NOT yet been specifically gate-reviewed for a
   prover. This iter I intend to dispatch a prover at `lem:modules_restrict_basicOpen` (frontier, no deps) and
   continue up the chain. Apply the HARD GATE: is each block complete (statement + `\lean{}` + `\uses{}` +
   informal proof at formalize-level detail) and correct? Report `complete`/`correct` per block and any
   must-fix so I can gate the P1a prover dispatch.

Report per-chapter checklist + the unstarted-phase proposals as usual.
