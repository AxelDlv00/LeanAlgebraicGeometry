# Strategy Critic Report

## Slug
finish

## Iteration
080

## Routes audited

### Route: A — acyclic-resolution comparison (CHOSEN, only live route)

- **Goal-alignment**: PASS — the augmented Čech complex `0→F→C⁰→C¹→⋯` (`Cᵖ = ∏_σ (j_σ)_*(F|_{U_σ})`) is exactly the standard resolution whose `f_*`-cohomology computes `Rⁱf_*F` via Leray (015E). End-state matches the §Goal isomorphism.
- **Mathematical soundness**: PASS — the two pillars are correct and standard:
  - (i) `cechAugmented_exact`: the augmented Čech complex of any open cover is a resolution of `F` (locally split by the trivial-cover contracting homotopy). Sound.
  - (ii) `cechTerm_pushforward_acyclic`: `Rⁱf_*((j_σ)_*(F|_{U_σ})) = 0` for `i>0`. The chain is correct: `U_σ` is affine (intersection of affine cover pieces in a **separated** `X`, via the affine-diagonal lemma `lemma-affine-diagonal`); `(j_σ)_*` preserves injectives (its left adjoint `j_σ^*` = restriction is exact); `f∘j_σ : U_σ → S` is an **affine morphism** because `U_σ` is affine and `S` is separated (graph `Γ` is a closed immersion since `S` separated, composed with the affine projection `U_σ×S→S`); an affine morphism has vanishing higher direct images of quasi-coherent sheaves (`lemma-relative-affine-vanishing`). Each hypothesis (`X.IsSeparated`, `S.IsSeparated`, quasi-coherence) is genuinely load-bearing.
  - Assembly via P4 `rightDerivedIsoOfAcyclicResolution` — one abstract lemma, no spectral sequences. I read the capstone proof body (`CechToHigherDirectImage.lean:198–219`); the signature and the three-step assembly (resolution input → termwise acyclicity → P4 comparison + `f_*C•` rewrite) match STRATEGY verbatim.
- **Verdict**: SOUND

### Route: A §P5b — capstone assembly (DONE iter-079; frozen-decl resolved)

- **Goal-alignment**: PARTIAL — see faithfulness note below. The deliverable matches the **project's stated goal** (§Goal, and the directive's own project-goal paragraph: "𝒰 a finite affine open cover" + separated `f`,`X`,`S`) exactly. It is, however, the **separated specialization** of canonical Tag 02KE, not 02KE in full generality.
- **Mathematical soundness**: PASS — the proved statement is TRUE. I verified the live signature `cech_computes_higherDirectImage [HasInjectiveResolutions X.Modules] (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] [X.IsSeparated] [S.IsSeparated] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i)) (F) (hF : F.IsQuasicoherent) (i) (hres : …) : Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` — identical to STRATEGY §P5b.
- **Sunk-cost reasoning detected**: no — the routes are justified on merits, not on prior investment.
- **Infrastructure-deferral detected**: no — `[HasInjectiveResolutions X.Modules]` and the `hres` family are carried as explicit, satisfiable hypotheses standing in for the missing Mathlib instance `IsGrothendieckAbelian (SheafOfModules R)`. They do not make the statement vacuous (injective resolutions exist; only the *instance* is absent upstream). Honestly disclosed in §Mathlib gaps. This is an accepted upstream dependency, not a goal-weakening.
- **Phantom prerequisites**: none — `rightDerivedIsoOfAcyclicResolution`, `higherDirectImage`, `CechComplex`, `cechTerm_pushforward_acyclic`, `cechAugmented_to_acyclicResolutionInput` are all project-built and referenced consistently.
- **Verdict**: SOUND (with the faithfulness qualification under "Must-fix" below — a labeling fix, not a math fix)

## Format compliance

- **Size**: 84 lines / 8971 bytes — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — substantial iter-tagged narrative in the **prose** sections (not just the `## Completed` `Iters` column, which is allowed). Representative: in §Goal, *"The deliverable … is PROVED, 0 sorries (iter-079). … (iter-080: the user dropped the old false-as-signed frozen sibling and its protection entry …)"*; in §Routes A §P5b, *"**Frozen-signature block — RESOLVED iter-080:** the old protected … was FALSE … The user dropped that decl …"* and *"(iter-078 strategy-critic's sanctioned lowest-risk fallback)"*. This per-iter history belongs in `iter/iter-NNN/plan.md`.
- **Accumulation detected**: no material accumulation — no completed phase left in the active table; the single active row ("Polish") is genuinely pending. `## Completed` is at 12 rows (the bound); cells are dense but single-line. Acceptable, at the edge.
- **Table discipline**: PASS — both tables have the required columns; `Status: NEXT` is a short inline tag.
- **Format verdict**: DRIFTED — driven solely by per-iter narrative bloat in the prose sections. Trim the iter-080/079/078 storytelling from §Goal, §Phases, and §Routes to one-line present-tense facts; move the "user dropped the frozen sibling" history to the iter sidecar.

## Specific question answers

**Q1 — Is the deliverable a TRUE and faithful formalization of Tag 02KE?**
TRUE: yes (verified statement + sorry-free body; see below). FAITHFUL: with one qualification. Canonical Tag 02KE (`lemma-cech-cohomology-quasi-coherent`) hypothesizes only that **all intersections `U_{i₀…iₚ}` are affine** (the affine-diagonal condition, `lemma-affine-diagonal`), which is strictly *weaker* than "each piece affine + `X` separated." The deliverable therefore proves the **separated case**, and does so in the **relative** (`Rⁱf_*`) form — of which absolute 02KE is the `S = Spec k` specialization. Net: the deliverable is a *generalization* of 02KE in the relative direction and a *specialization* in the hypothesis direction (separated, not merely affine-diagonal). It faithfully formalizes the separated relative case; it does NOT cover the non-separated-but-affine-diagonal generality of literal 02KE. STRATEGY discloses this ("Scope: the X-separated specialization of Tag 02KE"), and the §Goal statement is itself stated with the separated hypotheses, so there is no internal goal/deliverable mismatch — only a risk of *overclaiming* "Tag 02KE" without the "separated case" qualifier.

**Q2 — Is the ℙ¹/O(−2) counterexample correct, and is dropping the general form the right call?**
Correct. The general form (general `X.OpenCover`, only `[IsSeparated f]`, no affineness) fails: take the trivial one-element cover `𝒰={𝟙 X}` of `X=ℙ¹` with `f:ℙ¹→Spec k`, `F=O(−2)`. The Čech complex of a one-element cover is `F` in degree 0, so `Hⁱ(Č•)=0` for `i>0`; but `R¹f_*F = H¹(ℙ¹,O(−2)) = k ≠ 0` (Serre duality `H¹(O(−2)) ≅ H⁰(O)^*`). `f` is separated (`ℙ¹` projective), so `[IsSeparated f]` holds while the conclusion fails — affineness of the cover is essential. Dropping the statement is the **right call**: it is *false*, not merely unproven, so it cannot be carried as an "open goal." (One *could* later carry the genuinely-correct full-02KE generalization — all-intersections-affine, non-separated allowed — as a real open goal, but that is a different, true statement.) Removing the previously-frozen FALSE signature is moreover a soundness *necessity*: a false signature standing as a project `sorry` would make the headline deliverable an unprovable statement.

**Q3 — Remaining strategic gaps / unsound claims before declaring complete?**
- **Sorry-freeness verified.** The only two `sorry` tokens under `AlgebraicJacobian/Cohomology/*.lean` are **stale docstrings** (`CechSectionIdentificationLeg.lean:15` "Carries the residual sorry `coreIso_comm_leg`" and `CechSectionIdentification.lean:20`). I read `coreIso_comm_leg` (Leg.lean:1544–1609): it is a complete term/tactic proof with **no** `sorry`. So the project-wide inline-`sorry` = 0 claim holds; the stale comments are exactly the "Leg:15 stale docstring" Polish residue.
- **Axiom-clean gate is still pending and is the planner's, not mine.** STRATEGY correctly conditions completion on a full `lake build` confirming kernel-only / 0-axiom. I did not run that build (read-only critic; it is a multi-module rebuild). "0 project axioms / kernel-only" must be confirmed by that gate before declaring complete — it should not be asserted as already-verified.
- **Redundant `[X.IsSeparated]`** (derivable from `[IsSeparated f]` + `[S.IsSeparated]`) is carried verbatim to match the producer. Harmless to soundness; a minor faithfulness blemish, already slated for Polish.

## Must-fix-this-iter

- §P5b / §Goal: **faithfulness labeling** — qualify "formalization of Tag 02KE" as "the **separated case** of (the relative form of) 02KE" wherever the deliverable is described (STRATEGY and the blueprint capstone lemma), so the deliverable is not oversold as full-generality 02KE. The statement is true; only the *claim about what it formalizes* needs the qualifier. (CHALLENGE-level only as a labeling fix; no math change.)
- Format: DRIFTED — trim per-iter narrative (iter-078/079/080 storytelling) from the §Goal, §Phases, and §Routes prose to present-tense one-liners; relocate the "user dropped the frozen sibling" history to the iter sidecar.
- Completion gate: do not mark the project complete until the full `lake build` confirms 0 sorries **and** axiom-clean across the cone; "0 axioms" is currently an assertion, not a verified result.

## Overall verdict

SOUND. The strategy is mathematically correct and the deliverable `cech_computes_higherDirectImage` is a TRUE, sorry-free formalization that matches the project's own stated goal. The Route-A argument (augmented Čech resolution + termwise `f_*`-acyclicity via "`f∘j_σ` affine because `U_σ` affine and `S` separated" + Leray) is the standard textbook proof with every hypothesis load-bearing, and the ℙ¹/O(−2) counterexample correctly justifies dropping the false general signature rather than carrying it as an open goal. No infrastructure-deferral pattern is present: the carried `HasInjectiveResolutions`/`hres` hypotheses stand in for a genuinely-absent Mathlib instance and are honestly disclosed, not a goal-weakening. Two non-blocking items remain before "complete" can be declared: (a) the deliverable should be labeled the **separated case** of relative Tag 02KE rather than full 02KE (it proves strictly more in the relative direction and strictly less in hypothesis generality — the non-separated-but-affine-diagonal case of literal 02KE is not covered), and (b) the full-build / axiom-clean gate, on which STRATEGY rightly conditions completion, must actually pass — "0 project axioms" is asserted but not yet verified in the strategy text. Format is DRIFTED on per-iter narrative bloat only.
