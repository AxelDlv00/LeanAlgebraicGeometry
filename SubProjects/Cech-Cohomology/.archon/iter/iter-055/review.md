# iter-055 review

## Overall progress this iter
- **Total sorry:** 5 → **11** (`+6`). All six new are `sorry`-stub signatures in the NEW scaffold
  file `CechSectionIdentification.lean` (the iter-054-recommended Sub-brick A extraction). No
  previously-open sorry closed; **none forced/papered** — every residual is an honest, correctly-typed
  hole (auditor-confirmed). Pre-existing holes unchanged: `CechAcyclic.lean:110` dead `affine`,
  `CechHigherDirectImage.lean:780` frozen protected P5b; the two prover-touched residuals
  (`OpenImmersionPushforward.lean:306/372`, `CechAugmentedResolution.lean:229`) carried over reshaped.
- **Build:** ⚠️ **RED.** `CechSectionIdentification.lean` fails to compile (signature-level errors:
  `open Scheme.Modules` before `namespace`; `∏` vs `∏ᶜ` at :126; cascade `Over.mk`/`evaluation`) and
  is imported by the root `AlgebraicJacobian.lean:15`, so `lake build` fails. Review verified
  first-hand via `lake build AlgebraicJacobian.Cohomology.CechSectionIdentification` (exit 1). The two
  prover files each build standalone with only their honest `sorry` warnings.
- **Lanes planned 2, ran 2** (both PARTIAL-with-progress) + a planner-phase structural round
  (scaffolder + writer + analogist + refactor). **+6 axiom-clean completed decls;** `CombinatorialCech.Dependent`
  deprivatized.
- **dag-query:** gaps = 0; unmatched = 7 (6 new helpers + dead `CechAcyclic.affine`). `sync_leanok`
  ran iter-055 (sha `a42431a`, +2/−3). **blueprint-doctor: no structural findings.**

## Headline — iter-054's structural recommendation executed, but the scaffold shipped RED
The decisive event is a process failure, not a math wall. iter-054 review prescribed extracting the
shared L1 bridge `Γ(V, pushPullObj F Y) ≅ ∏_σ Γ(U_σ∩V, F)` into a standalone foundational file and
deprivatizing the `Dependent` engine. The planner did exactly that — new `CechSectionIdentification.lean`
with 6 well-decomposed, blueprint-faithful stubs (lvb confirms every signature matches the Sub-brick A
chapter) plus rich planner-strategy comments, and a `refactor` deprivatizing `CombinatorialCech.Dependent`.
This is the right structural move and sets up small ready pieces (Stub 3 LOW, Stub 1 MEDIUM) for next iter.

**But the scaffold file was committed non-compiling AND wired into the root**, so the whole package
build is RED. The errors are trivial (open-before-namespace, `∏`→`∏ᶜ`) and all 6 stub statements are
sound — but a `lean-scaffolder` is supposed to emit compiling sorry-stubs, and whoever added the root
import did not verify `lake build`. The CechAugmentedResolution prover caught and prominently flagged
this in its task result ("the project build root is RED"); it correctly held back its own import and
left its residual documented rather than papering. That honesty is the reason this is recoverable in
one cheap fix next iter.

## Lane 2 — genuine advance: open-immersion corepresentability half discharged
`higherDirectImage_openImmersion_acyclic` now has its **geometric** half done: the sections functor
`Γ(j⁻¹W,−)` is corepresented by `jShriekOU(j⁻¹W)` (`sectionsFunctorCorepIso`), and
`rightDerivedNatIso` transports right-derived functors across that NatIso, reshaping the residual
(line 306) to `IsZero ((preadditiveCoyoneda (op (jShriekOU(j⁻¹ᵁW)))).rightDerived q H)`. The remaining
leaf is (i) `coyoneda.rightDerived ≅ Ext^q` (off-the-shelf) + (ii) a **change-of-scheme** Serre
vanishing of that Ext over the affine `j⁻¹W` — genuine new work, the dominant wall (the prover's
memory note flags (b) as dominant; do not treat it as near-rfl). `_comp` was re-signed to canonical
`A ≅ B` per iter-054 D2 and is correctly blocked on `_acyclic`. Five axiom-clean corepresentability
decls fell out. This is a route converging onto its true foundation.

## Lane 1 — consumer glue built, residual re-routed into the new scaffold
The prover added the axiom-clean `isZero_homology_of_iso_homotopy_id_zero` (combines `D ≅ D'` with
`Homotopy (𝟙 D') 0` into `IsZero (D.homology p)`), confirmed the one-line discharge is type-correct
against the sibling stubs, and held back the import because the sibling doesn't compile. `cechAugmented_exact`
is now PARTIAL for 5 consecutive iters — but iter-055 is the sanctioned structural extraction, not a
plain re-route, so it is not flagged as churn provided the next iter closes sub-stubs (start LOW/MEDIUM)
rather than re-routing again.

## Soundness — confirmed three ways
- **No forced mathematics, no papering.** Both prover lanes stopped at honest residuals; the scaffold
  stubs are explicit `sorry`s, not fake statements.
- **lean-auditor `iter055`:** 2 must-fix (the two build-breaking signature errors), 2 major (`Over.mk`
  cascade; cross-file `isZero_of_faithful_preservesZeroMorphisms` duplication), 1 minor. Explicitly
  confirmed: all 6 completed decls non-vacuous + `Classical.choice`-free; **no subsingleton-coherence
  kernel trap** (every `Subsingleton.elim` is on a genuine zero object; the `congr 1` on `op a = op b`
  closes by thin-preorder proof-irrelevance — both sound); all 3 residual sorries are honest,
  correctly-typed holes matching documented intent.
- **lvb `openimm`** (signatures match; honest residuals; MAJOR private/public pin mismatch on
  `isAffineHom_of_affine_separated`) + **lvb `cechsectionid`** (all 6 stub signatures match the
  blueprint Sub-brick A chain; only `∏`→`∏ᶜ` flagged; blueprint adequate).

## Manual blueprint markers updated
- **None.** No `\mathlibok` applies (6 new completed decls are project constructions). No `\lean{}`
  rename (the 6 unmatched helpers are NEW → coverage debt, not corrections). No stale `\notready`.
  The `isAffineHom_of_affine_separated` private/public pin mismatch and the missing duplication NOTE
  on `jShriekOU_homEquiv_nat` are surfaced in `recommendations.md` for the planner/writer (prose +
  Lean-visibility decisions, out of the review marker domain).

## For the next plan agent (top of recommendations.md)
1. **Repair the RED build first** (signature fixes in `CechSectionIdentification.lean`; re-verify
   `lake build` green) before any prover lane. This is the must-fix.
2. Lane 2: close line 306 via coyoneda→Ext + the change-of-scheme Serre wall (effort-break (ii)).
3. Lane 1: prove the 6 Sub-brick A stubs bottom-up (Stub 3 → 1 → 2[hard] → 4/5/6), then re-add the
   held-back import and one-line-discharge `hSec`.
4. Blueprint the 6 unmatched helpers; fix the `isAffineHom_of_affine_separated` pin.
