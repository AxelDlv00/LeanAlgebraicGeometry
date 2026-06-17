# Session 55 (iter-055) — review summary

## Metadata
- **Iteration / session:** 055 / session_55
- **Model:** claude-opus-4-8
- **Inline sorry:** 5 → **11** (`+6`). Breakdown of the +6: all six are NEW `sorry`-stub
  signatures in the new scaffold file `CechSectionIdentification.lean` (the iter-054-recommended
  Sub-brick A extraction). No previously-open sorry was closed; **none forced/papered** (every
  residual is an honest, correctly-typed hole — auditor-confirmed).
- **Build:** ⚠️ **RED.** `CechSectionIdentification.lean` does not compile (signature-level errors,
  see below) and it is imported by the root `AlgebraicJacobian.lean`, so the package build fails.
  The two prover-touched files (`OpenImmersionPushforward.lean`, `CechAugmentedResolution.lean`)
  each compile standalone with only their honest `sorry` warnings.
- **Net new completed (axiom-clean) decls:** +6 — `isZero_homology_of_iso_homotopy_id_zero`
  (CechAugmentedResolution) and the OpenImmersion corepresentability block
  (`sectionsFunctorCorepIso`, `rightDerivedNatIso`, `jShriekOU_homEquiv_nat`,
  `sectionsFunctor_additive`, `toPresheafOfModules_additive`). Plus a structural refactor:
  `CombinatorialCech.Dependent` engine deprivatized (planner-phase `refactor`).
- **dag-query:** gaps = 0; unmatched = 7 (6 new helpers + pre-existing dead `CechAcyclic.affine`).
- **sync_leanok:** ran iter-055 (sha `a42431a`, +2/−3, chapter `Cohomology_CechHigherDirectImage.tex`).
- **blueprint-doctor:** no structural findings.

## Character of the iteration
This was a **structuring / scaffolding iter**, not a sorry-closing one. It executed the iter-054
review's explicit structural recommendation: extract the shared L1 bridge
`Γ(V, pushPullObj F Y) ≅ ∏_σ Γ(U_σ∩V, F)` into a standalone file reusable by both P5a lanes, and
deprivatize the `CombinatorialCech.Dependent` engine so Sub-brick B becomes a one-call consumer.
The planner did this via a `lean-scaffolder` (new file), a `blueprint-writer` (Sub-brick A chapter),
a `mathlib-analogist` consult, and a `refactor` (deprivatize). Two genuine prover advances also
landed (the OpenImmersion corepresentability half + the CechAugmented consumer glue), but the
headline cost is that the scaffold file was committed **non-compiling and wired into the root**.

---

## Target 1 — `OpenImmersionPushforward.lean` (Lane 2): corepresentability half DISCHARGED

`higherDirectImage_openImmersion_acyclic` (line 250) was advanced by building the **geometric
corepresentability bridge** and using it to reshape the residual:

- `pushforwardSectionsFunctor j W = sectionsFunctor (j ⁻¹ᵁ W)` is **`rfl`** (also
  `pushforward j ⋙ sectionsFunctor W = sectionsFunctor (j⁻¹ᵁW)`).
- `sectionsFunctorCorepIso V : sectionsFunctor V ≅ preadditiveCoyoneda.obj (op (jShriekOU V))`
  — `Γ(V,−)` corepresented by `jShriekOU V` (built from `jShriekOU_homEquiv` naturality).
- `rightDerivedNatIso` transports right-derived functors across a `NatIso`.
- Inserting `IsZero.of_iso ((rightDerivedNatIso (sectionsFunctorCorepIso (j⁻¹ᵁW)) q).app H)` turns
  the goal `IsZero ((sectionsFunctor (j⁻¹ᵁW)).rightDerived q ...)` into
  `IsZero (((preadditiveCoyoneda.obj (op (jShriekOU (j⁻¹ᵁW)))).rightDerived q).obj H)` (line 306).

**Residual (line 306, honest):** two pieces remain — (i) the pure homological-algebra
identification `(preadditiveCoyoneda (op P)).rightDerived q ≅ Ext^q(P,−)` via
`InjectiveResolution.extAddEquivCohomologyClass ∘ homologyAddEquiv`, turning the goal into
`IsZero (Ext (jShriekOU (j⁻¹ᵁW)) H q)`; and (ii) the dominant wall — a **change-of-scheme** Serre
vanishing of that `Ext` over the affine `j⁻¹ᵁW` (transport `affine_serre_vanishing` /
`cech_eq_cohomology_of_basis` to a `BasisCovSystem` on the affine scheme `U`).

`higherDirectImage_openImmersion_comp` (line 348) was **re-signed** to the canonical `A ≅ B`
(matches blueprint, per iter-054 D2); body `sorry` (line 372), correctly blocked on `_acyclic`.

**Auditor verdict (file COMPILES):** all 5 new corepresentability decls SOUND, non-vacuous, no
`Classical.choice` smuggling, no subsingleton-coherence kernel trap; both `sorry`s are honest
residuals matching documented intent.

## Target 2 — `CechAugmentedResolution.lean` (Lane 1): consumer glue built, residual re-routed

The prover added the axiom-clean consumer glue
`isZero_homology_of_iso_homotopy_id_zero : (D ≅ D') → Homotopy (𝟙 D') 0 → IsZero (D.homology p)`
(line 89, `{propext, Classical.choice, Quot.sound}`), which combines the section-complex
identification (`cechSection_complex_iso`, sibling) with the contracting homotopy
(`cechSection_contractible`, sibling) into the `hSec` `IsZero` residual.

The intended one-line discharge
`exact isZero_homology_of_iso_homotopy_id_zero (cechSection_complex_iso 𝒰 F V) p (cechSection_contractible 𝒰 F V i hiV)`
is type-correct against the sibling signatures, **but the import is held back** because
`CechSectionIdentification.lean` does not compile. The residual `Homotopy (𝟙 D) 0` is left as a
documented `sorry` (line 229). The prover prominently flagged the RED root build in its task result.

## Target 3 — `CechSectionIdentification.lean` (NEW scaffold): 6 stubs, build RED

The shared Sub-brick A chain was scaffolded with 6 `sorry`-stubbed `noncomputable def`s plus rich
`/- Planner strategy: -/` comments: `cechBackbone_left_sigma`, `pushPull_sigma_iso`,
`pushPull_leg_sections`, `pushPull_eval_prod_iso`, `cechSection_complex_iso`,
`cechSection_contractible`. **lvb confirmed all 6 signatures faithfully match the blueprint**
Sub-brick A lemmas (`lem:cech_backbone_left_sigma … lem:cechSection_contractible`); the blueprint
chapter is detailed enough to guide formalization.

**But the file does not compile** (`lake env lean` / `lake build` both fail). Errors (auditor-confirmed
all repairable, not deep type errors):
1. **Line 37** — `open CategoryTheory Limits Scheme.Modules Opposite` is placed BEFORE
   `namespace AlgebraicGeometry` (line 39), so `Scheme.Modules` resolves to nothing (the real name
   is `AlgebraicGeometry.Scheme.Modules`). **Root error**; cascades into 2 and 4. Fix: move the
   `open` to AFTER the `namespace` line (as the sibling files do).
2. **Lines 77, 164** — `Unknown identifier 'Over.mk'` (likely resolves once the namespace error is
   fixed; if not, needs the `Over` import/qualification check).
3. **Line 126** — `∏ fun σ =>` should be `∏ᶜ fun σ =>` (Stub 4 at line 203 correctly uses `∏ᶜ`).
   Syntax error → the type of `pushPull_sigma_iso` never elaborates.
4. **Lines 258–259** — `Unknown identifier 'evaluation'` + cascade `GV.PreservesZeroMorphisms`
   (cascade from 1; the identical construction compiles in `CechAugmentedResolution.lean:204-205`).

Because the root `AlgebraicJacobian.lean:15` imports this module, the **whole package build is RED**.

---

## Subagent findings
- **lean-auditor `iter055`** (`logs/iter-055/lean-auditor-iter055-report.md`): 2 must-fix (the two
  signature-level errors that break the build — namespace/open placement at :37, `∏`→`∏ᶜ` at :126),
  2 major (`Over.mk` cascade; cross-file duplication of `isZero_of_faithful_preservesZeroMorphisms`),
  minor (one >100-char line). **Confirmed all completed decls SOUND** (no kernel-soundness
  subsingleton trap; explicit `Subsingleton.elim` on genuine zero objects; no `Classical.choice`
  smuggling; all 3 residual sorries are honest, correctly-typed holes).
- **lvb `openimm`** (`logs/iter-055/lean-vs-blueprint-checker-openimm-report.md`): signatures match
  blueprint; `_acyclic`/`_comp` sorries are honest residuals on substantive claims. **MAJOR:**
  `isAffineHom_of_affine_separated` is `private` but the blueprint `\lean{}` pins it as public →
  `sync_leanok` cannot resolve the qualified name. **Minor:** `jShriekOU_homEquiv_nat` private,
  import-isolation duplicate, no blueprint NOTE. The 5 new corepresentability decls are not in the
  blueprint sketch (coverage debt).
- **lvb `cechsectionid`** (`logs/iter-055/lean-vs-blueprint-checker-cechsectionid-report.md`): all 6
  stub signatures match the blueprint Sub-brick A chain; only the `∏`→`∏ᶜ` notation fix flagged.
  Blueprint detailed enough.

## Blueprint markers updated (manual)
- **None this iter.** No `\mathlibok` applies (the 6 new completed decls are project constructions,
  not Mathlib re-exports). No `\lean{...}` rename (the 6 unmatched helpers are NEW, not renamed —
  they are coverage debt for the planner to blueprint, not corrections). No stale `\notready` to
  strip (nothing new landed; all new stubs carry `sorry`). The private/public pin mismatch on
  `isAffineHom_of_affine_separated` and the missing duplication NOTE on `jShriekOU_homEquiv_nat`
  are surfaced in `recommendations.md` for the planner/writer (authoring prose is out of my domain).

## Notes (LOW)
- Cross-file code duplication of `isZero_of_faithful_preservesZeroMorphisms` (two namespaces,
  import-chain reason documented) — candidate for a shared utilities module; not urgent.
