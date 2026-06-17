# Session 173 — Review of iter-173

## Session metadata

- **Session number / iteration**: 173
- **Sorry count entering iter-173**: 20 (per iter-172 review close).
- **Sorry count leaving iter-173**: 24 (verified by `lake build AlgebraicJacobian` — 24 `declaration uses sorry` warnings across `AbelianVarietyRigidity.lean` (2), `Genus0BaseObjects.lean` (8), `Picard/RelativeSpec.lean` (6), `RiemannRoch/WeilDivisor.lean` (5), `Jacobian.lean` (2), `RigidityKbar.lean` (1)). NET +4 = Lane A −1 (`gmScalingP1_chart`) + Lane B +6 (file-skeleton scaffolds) + Lane D −1 (`degree_hom` closed + `True` placeholder retired).
- **Lanes attempted**: 4 (Lane A Genus0BaseObjects, Lane B Picard/RelativeSpec (FIRST landing), Lane D RiemannRoch/WeilDivisor, Lane "umbrella" AlgebraicJacobian).
- **Build status**: `lake build AlgebraicJacobian` exit 0 (8336 jobs, 24 sorry warnings only).
- **Headline**: PARTIAL-acceptable per the iter-173 plan acceptance grid. Lane A 1/3 PRIMARY closed (PRIMARY 1 `gmScalingP1_chart` body axiom-clean via the iter-173 analogist bridge), Lane B all 6 stubs landed (file FIRST landing), Lane D 2/2 PRIMARY closed axiom-clean. Project sorry total 20 → 24 (NET +4 expected per the plan's Lane B +6 projection).

## Per-target summary

### Lane A — `AlgebraicJacobian/Genus0BaseObjects.lean`

**Status**: PARTIAL-low — PRIMARY 1 closed; PRIMARY 2 + 3 left as top-level scaffold sorries.

**PRIMARY 1: `gmScalingP1_chart` body (L911) — CLOSED axiom-clean.**

Recipe (per analogist `chart-bridge173` bridge):
- Helper 1: `awayι_comp_PLB_hom` (~12 LOC) — `Proj.awayι 𝒜 f _ _ ≫ PLB.hom = Spec.map (algebraMap kbar (Away 𝒜 f))` via `awayι_toSpecZero` + `Spec.map_comp` + `algebraKbarAway` defeq.
- Helper 2: `gmScalingP1_cover_X_iso` (~32 LOC) — `(gmScalingP1_cover kbar).X i ≅ Spec ((Away 𝒜 (X i)) ⊗[kbar] GmRing kbar)` built via `pullbackSymmetry ≪≫ pullbackRightPullbackFstIso ≪≫ pullback.congrHom _ ≪≫ pullbackSpecIso`. Pattern-matches on `i : Fin 2` because `(![X 0, X 1]) i = X i` is not definitional.
- Chart body (~20 LOC): `(gmScalingP1_cover_X_iso kbar i).hom ≫ Spec.map (CommRingCat.ofHom chartMap) ≫ Proj.awayι _ (X i) _ _`.

Axiom check: `{propext, Classical.choice, Quot.sound}` only.

**Dead-ends recorded:**
- Generic-`i` `gmScalingP1_cover_X_iso` (without pattern matching) FAILED: `(![X 0, X 1]) i = X i` is NOT definitional. Fix: pattern-match on `i : Fin 2` inside the iso body.
- `fin_cases i` in a term-level definition FAILED for the same goal type (non-Prop position). Fix: `match i with` directly.

**PRIMARY 2: `gmScalingP1_over_coherence` (L961) — DEFERRED.** Top-level scaffold sorry. Closure plan in task result: needs `gmScalingP1_chart_PLB_eq` private helper bundling (a) kbar-linearity of `chartMap.comp (algebraMap kbar Away) = algebraMap kbar (Away ⊗ GmRing)` and (b) bridge-structure `iso.hom ≫ Spec.map includeLeft = pullback.snd`. ~50–60 LOC iter-174 helper.

**PRIMARY 3: `gmScalingP1_chart_agreement` (L944) — DEFERRED.** Top-level scaffold sorry. Diagonal cases close in ~3 LOC each via `fst_eq_snd_of_mono_eq` (open-immersion mono). Cross cases need the same chart-bridge framework as PRIMARY 2 plus an `Algebra.TensorProduct.tmul_mul_tmul`-driven ring identity (~30–40 LOC per cross case).

**Helper-budget compliance**: per iter-173 plan, helper-budget = 0 net was relaxed to 2 helpers (the analogist's recipe was named explicitly as the single structural ingredient; the bridge factored into 2 named lemmas). Both helpers are load-bearing for `gmScalingP1_chart` and will be reused by PRIMARY 2 and PRIMARY 3 closures.

### Lane B — `AlgebraicJacobian/Picard/RelativeSpec.lean` (NEW FILE)

**Status**: COMPLETE on the 6-pin scaffold target; 1 NEW helper (`structureMorphism`) introduced as a structural necessity.

All 6 pinned declarations landed:
- `Scheme.QcohAlgebra` (L98) — typed `sorry : Type (u+1)` (TYPE-level placeholder; iter-174+ unpacks to a `SheafOfModules + Mon_Class` structure).
- `Scheme.RelativeSpec` (L123) — typed `sorry : Scheme.{u}`.
- `Scheme.RelativeSpec.UniversalProperty` (L169) — encoded as substantive `IsAffineHom (structureMorphism 𝒜)` (weaker than the chapter's Yoneda-bijection pin; iter-174+ refinement scheduled).
- `Scheme.RelativeSpec.affine_base_iff` (L193) — encoded as substantive `IsAffine ((Spec R).RelativeSpec 𝒜)` (weaker than chapter's canonical-iso pin).
- `Scheme.RelativeSpec.base_change` (L223) — encoded as substantive `∃ 𝒜', Nonempty (pullback ≅ T.RelativeSpec 𝒜')` (existential-weakened; iter-174+ refines to named `pullbackQcoh`).
- `Scheme.RelativeSpec.functor` (L251) — concrete body `fun 𝒜 => Over.mk (structureMorphism 𝒜)` (propagates sorry through helper).

NEW helper: `Scheme.RelativeSpec.structureMorphism` (L134) — typed `sorry`. Consumed by `UniversalProperty`, `base_change`, `functor`.

Reflexive-iso placeholder pattern was tried and explicitly REJECTED by the prover (recorded as "banned pattern #1: `Iso.refl _` tautology") — replaced with substantive-consequence encodings.

**Reviewer findings** (lean-vs-blueprint-checker `relspec173`, lean-auditor `iter173`):
- All 4 weakened-type encodings have substantive-consequence types (not `Iso.refl`-tautologies). Bodies are honest sorries; no `Classical.choice _` patterns; no axiom declarations.
- 4 declaration-naming issues flagged as **major**: `UniversalProperty` (overpromises vs. `IsAffineHom`), `affine_base_iff` (not an iff), `functor` (not a Functor), `base_change` (existential rather than canonical iso). Each iter-174 refinement is documented in the file's docstring + the chapter prose.
- Lean-auditor flagged the file-skeleton's TYPE-level `sorry` on `QcohAlgebra` as **must-fix-this-iter** (since every theorem in the file quantifies over `X.QcohAlgebra`). Lean-vs-blueprint-checker classified it as a deliberate scaffold (not must-fix). Net: this is a hard precondition for any iter-174+ body work but does NOT contaminate Prop-level reasoning kernel-wise.
- Lean-auditor flagged 13 `iter-174+ ...` forward-looking excuse-comments in the file as a single must-fix-aggregate. They are transparent scaffold annotations, not concealments — soft-finding for the review but should be revisited iter-174 once bodies land.
- The blueprint chapter (`Picard_RelativeSpec.tex`) was flagged for a missing verbatim Stacks proof quote on `thm:relative_spec_univ` (`% SOURCE QUOTE PROOF: TODO retrieve from references/stacks-constructions.tex`). NOT gating iter-173 work but iter-174 prover work on `UniversalProperty` body will need it filled.

### Lane D — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

**Status**: COMPLETE per plan target — both PRIMARY items closed axiom-clean. 5 sorries remain (all gated, NOT ATTEMPTED iter-173 per directive).

**PRIMARY 1: `Scheme.PrimeDivisor` (L93) — REFACTORED axiom-clean.**

Recipe (per `wd-spec-refine` writer recipe): dropped `isCodim1AndIntegral : True := trivial` placeholder, added `coheight : Order.coheight point = 1`. Mathlib `Order.coheight : α → ℕ∞` is total on `Scheme.carrier` via the standard specialisation preorder — no new typeclass threading needed.

Closes iter-172 lean-auditor must-fix-this-iter on the `True` placeholder.

**PRIMARY 2: `Scheme.WeilDivisor.degree_hom` (L207) — CLOSED axiom-clean.**

Recipe: `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)` (one-line `AddMonoidHom`-packaging via the `liftAddHom` universal property). Helper `degree_hom_apply` (L210, `@[simp]`) added as a downstream-callability bridge (`degree_hom D = degree D` by `Finsupp.liftAddHom_apply`).

**Dead-ends recorded:**
- `Finsupp.sum_add_index` route (the objectives' suggestion) — NOT used. Hypothesis-discharge burden made `liftAddHom` cleaner.
- Manual `where toFun := degree; map_zero' := ...; map_add' := ...` structure literal — works but ~5 LOC longer.

**Reviewer findings** (lean-vs-blueprint-checker `wd173`):
- 9/9 substantive Lean declarations pinned in chapter. CLEAN — 0 new red flags.
- Optional polish (minor): add a one-line mention of `degree_hom_apply` to the `thm:divisor_degree_hom` Lean-encoding-scope paragraph.

**Lean-auditor `iter173` finding** (major + must-fix-this-iter on docstring):
- File-level section docstring at L70–77 references the OLD field name `isCodim1AndIntegral` and predicts an iter-173+ refinement that has already landed (under a different name `coheight`, different content). Outdated comment, misleads a reader.
- `noncomputable` on `degree_hom` is redundant (the body is computable).

I (review agent) am not permitted to edit `.lean` files; these must-fix items must be addressed by iter-174 plan-agent dispatch (refactor or in-prover-lane).

### Lane "umbrella" — `AlgebraicJacobian.lean`

**Status**: NO-OP (already correct, 18 imports / 0 sorries / 18 LOC). Imports include `AlgebraicJacobian.Picard.RelativeSpec` (Lane B target) and `AlgebraicJacobian.RiemannRoch.WeilDivisor` (Lane D target). The prover noted a build-state observation but did not edit the file.

## Key findings / patterns discovered

1. **`pullbackSymmetry ≫ pullbackRightPullbackFstIso ≫ pullback.congrHom ≫ pullbackSpecIso` is the canonical 4-step Mathlib chain for `pullback (pullback.fst _) _ ≅ Spec (R ⊗ S)`** — established this iter via `chart-bridge173` analogist + landed in `gmScalingP1_cover_X_iso`. The exact same pattern is used in Mathlib at `OpenCover.pullbackCoverAffineRefinementObjIso` (`Cover/Open.lean:160-166`). Reusable for any pullback-of-`Proj.awayι`-vs-`Spec.map` bridge.

2. **Pattern-match-on-`Fin n` in term-level isos** when generic-index reductions are not definitional — `(![X 0, X 1]) i = X i` requires `match i with | ⟨0, _⟩ => ... | ⟨1, _⟩ => ...` (cannot use `fin_cases i` at the term level in non-Prop position). Reusable for any explicit-vector-applied-to-`Fin n` reduction in a `Mathlib.Iso.trans` chain.

3. **`Finsupp.liftAddHom` beats manual `where`-form for `(α →₀ M) →+ N` packaging by ~5 LOC** — `liftAddHom (fun a ↦ h a)` packages the additivity precondition automatically; the manual structure literal `{ toFun := ..., map_zero' := ..., map_add' := ... }` requires hand-discharging additivity. Reusable for any free-abelian-group → AddMonoidHom construction.

4. **Substantive-consequence types are the right scaffold encoding when full Yoneda types are gated** — when the chapter pin is a natural bijection but the supporting infrastructure isn't there, encoding the Lean as a *structural consequence* (`IsAffineHom`, `IsAffine`, existential `∃ 𝒜', Nonempty (... ≅ ...)`) preserves the litmus test (non-tautological type) while deferring the strong statement to iter-N+1 refinement. Mark each weakened pin with `% NOTE: iter-N file-skeleton encodes weakened type X; iter-(N+1)+ refines to Y` in the chapter. This iter applied the NOTE pattern to 4 Picard_RelativeSpec.tex pins.

5. **Reviewers agree the file-skeleton-with-type-level-sorry pattern is acceptable IF documented** — lean-vs-blueprint-checker classifies `Type (u+1) := sorry` as "an unusual but legal pattern" when (a) docstring transparently describes the iter-(N+1)+ refinement plan as a concrete structure shape, (b) it does NOT make a false claim about a Prop-level theorem proof, and (c) no excuse-comment phrasing. Lean-auditor remains stricter and classifies it as must-fix-this-iter. Plan-agent should treat this as a "type-level scaffold needs body lane priority" iter-174 signal, not a "the landing was illegitimate" rejection.

## Blueprint markers updated (manual)

- `Picard_RelativeSpec.tex`, `thm:relative_spec_univ`: added `% NOTE: ...` flagging the iter-173 `IsAffineHom`-weakening vs. chapter's natural-bijection pin; iter-174+ refines to `RepresentableBy`.
- `Picard_RelativeSpec.tex`, `thm:relative_spec_affine_base`: added `% NOTE: ...` flagging the iter-173 `IsAffine`-weakening vs. chapter's canonical-iso-with-Γ pin and naming concern.
- `Picard_RelativeSpec.tex`, `thm:relative_spec_base_change`: added `% NOTE: ...` flagging the iter-173 existential-weakening vs. chapter's canonical-iso-with-named-pullback pin.
- `Picard_RelativeSpec.tex`, `thm:relative_spec_functorial`: added `% NOTE: ...` flagging the iter-173 object-level-function encoding vs. chapter's contravariant-Functor pin.

No `\mathlibok` added this iter (no new Mathlib re-export). No stale `\notready` strip needed (none on touched chapters). No `\lean{...}` corrections needed (all 6 Picard pins resolve; all 9 WD pins resolve; all 4 G0BO scaffold pins resolve to existing decls). Deterministic `sync_leanok` added 9 `\leanok` markers across `Picard_RelativeSpec.tex` + `RiemannRoch_WeilDivisor.tex` (per `.archon/sync_leanok-state.json`).

## Blueprint-doctor findings

Doctor reported (per `.archon/logs/iter-173/blueprint-doctor.md`):

- **Chapter coverage problems**: 2 — `Picard_LineBundlePullback.tex` covers `AlgebraicJacobian/Picard/LineBundlePullback.lean` (does not exist; chapter landed iter-173 plan-phase ahead of the file); `RiemannRoch_RRFormula.tex` covers `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (does not exist; chapter landed iter-173 plan-phase ahead).
- **Orphan chapters**: 2 — same two chapters not reachable from `content.tex`.

These are EXPECTED and INFORMATIONAL for iter-173: the iter-173 plan opened both chapters as preparatory scaffolds for iter-174+ prover lanes (Route A.1.b + RR.2). The plan-agent for iter-174 should add `\input{chapters/Picard_LineBundlePullback}` and `\input{chapters/RiemannRoch_RRFormula}` to `content.tex` and scaffold the two `.lean` files via prover dispatch to resolve.

## Recommendations for the next session

See `recommendations.md`.
