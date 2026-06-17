# Blueprint Reviewer Directive — iter-143

## Slug
iter143

## Strategy snapshot (one paragraph)

Project: formalize Christian Merten's Jacobian challenge (9 protected
declarations spread across `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`).
Active milestone is M2 (genus-0 witness `genusZeroWitness`) via the
shared cotangent-vanishing pile (pieces i + ii + iii) over an arbitrary
base field `k` (over-k commitment iter-127, base-independence finding
iter-141, operational-convention simplification iter-142). M3
(`positiveGenusWitness`) is off-critical-path (scaffold landed iter-134).
Pieces (i.a) closed iter-128→iter-132; piece (i.b) IN-FLIGHT iter-134→iter-142+
with Step 1 (`shearMulRight`) DONE iter-134, Step 3 (`relativeDifferentialsPresheaf_restrict_along_identity_section`)
DONE iter-136, and Step 2 BUNDLED 3-sub-sorry closure IN-FLIGHT:
**iter-142 closed d_map substantively (1 of 3) — d_app L637 + IsIso L720
(inside `isIso_of_app_iso_module ... (fun _ => sorry)`) remain.** Iter-143
is the post-PARTIAL strategic re-evaluation iter; the planner's
question is whether `RigidityKbar.tex` recipes for d_app + IsIso are
still prover-ready or need refinement after iter-142's empirical
shape-discoveries (`change`-fully-explicit on both sides, packaging
`NatTrans.naturality` via `rw [show ... from ...]`).

## Iter-142 prover-lane delta you should account for

`AlgebraicJacobian/Cotangent/GrpObj.lean` changes iter-142:
- **d_map at L643 → CLOSED substantively** via the iter-141 3-step
  ALIGN_WITH_MATHLIB chase, with two refinements over the chapter's
  recipe: (i) the explicit `change` must spell BOTH LHS+RHS (not just
  LHS), and (ii) `NatTrans.naturality_apply` must be packaged via
  `rw [show ... from ...]` because the bare lemma produces
  `ConcreteCategory.hom`-form equalities that don't unify with the
  goal's `RingCat.Hom.hom` / `CommRingCat.Hom.hom`-form terms.
- **d_app at L624 → not closed; the `change`-skeleton at L611–L618 was
  extended to spell out `ψ.app X .hom (φ_G.app X .hom a)` fully**,
  exposing the goal in canonical form. Body remains `sorry`; the
  4-step closure recipe (categorical equality → `comp_c_app` → adjunction
  transpose → `d_map` discharge) is unchanged but the Step 3
  adjunction-transpose chase (~20–40 LOC bespoke `NEEDS_MATHLIB_GAP_FILL`)
  is the load-bearing piece.
- **IsIso at L689 (now L720 after iter-142 shifts) → no change**.
  Iter-140 narrowing via `isIso_of_app_iso_module ... (fun _ => sorry)`
  preserved verbatim; prover priority-deferred items 2–4 of Route (b'2)
  (~195–365 LOC bundled) in favor of d_app + d_map.

Lean-auditor-review142 surfaced one MAJOR concern on this file:
`Cotangent/GrpObj.lean:719–721` `letI : IsIso ... := isIso_of_app_iso_module
... (fun _ => sorry)` propagates a `sorry`-tainted iso into downstream
`simp` consumers of `relativeDifferentialsPresheaf_basechange_along_proj_two`.
Auditor recommends **refactoring to extract the IsIso obligation into
a named sorry-bodied theorem** (rather than burying it inside a `letI`
term). The named theorem would carry the same residual sorry but make
the propagation auditable.

Sync_leanok mis-mark watch (iter-141 + iter-142 carry-over): `RigidityKbar.tex`
has three suspect `\leanok` markers — L406 (`lem:GrpObj_mulRight_globalises`),
L524 (`lem:GrpObj_omega_basechange_proj`), and L1152 (`lem:GrpObj_omega_basechange_proj_inv_derivation`).
All three sit on proof blocks whose underlying Lean declarations have
inline sorries; the deterministic `sync_leanok` phase marks the block
`\leanok` even though the body has sorry-bearing children. This is a
`sync_leanok`-handling concern (out of agent scope), surfaced for
informational purposes; the iter-143 planner is considering an
`archon-lean4:doctor` consult on the rule.

## Stable references

References summary index (`references/summary.md`):
- `challenge.lean` — original challenge file by Christian Merten;
  the formal statement of the missing definitions and theorems for
  the Jacobian of an algebraic curve. The Lean skeleton in
  `AlgebraicJacobian/` is a decomposition of this file; signatures
  here are authoritative.

## Files you read

- Every chapter under `blueprint/src/chapters/` (always read all 11):
  `AbelJacobi.tex`, `AlgebraicJacobian_Cotangent_GrpObj.tex` (pointer),
  `Cohomology_MayerVietoris.tex`, `Cohomology_SheafCompose.tex`,
  `Cohomology_StructureSheafAb.tex`, `Cohomology_StructureSheafModuleK.tex`,
  `Differentials.tex`, `Genus.tex`, `Jacobian.tex`, `Rigidity.tex`,
  `RigidityKbar.tex` (1349 LOC; heavy iter-141+ expansion).
- For Lean target line citations, the live Lean file is
  `AlgebraicJacobian/Cotangent/GrpObj.lean` (850 LOC, 3 inline sorries
  at L637 + L720 + L848 verified via `sorry_analyzer`).

## Special focus this iter

1. **Are `RigidityKbar.tex` recipes for d_app + IsIso still prover-ready
   after the iter-142 empirical shape-discoveries?** Specifically:
   - The d_app recipe at `RigidityKbar.tex:672–703` describes the
     categorical-witness factoring. Iter-142 validated the
     `change`-fully-explicit pattern and identified Step 3 (adjunction
     transpose ~20–40 LOC) as load-bearing. Is the chapter prose's
     recipe still aligned with what the prover should attempt iter-143?
   - The IsIso recipe at `RigidityKbar.tex:943–1073` describes Route
     (b'2) items 2–4 (~195–365 LOC bundled). Iter-142 prover deferred
     these — was the deferral well-founded (size mismatch with bundle)
     or does the chapter's recipe need decomposition into smaller
     prover-ready units?
   - **Implicit empirical lessons from iter-142 d_map closure** — the
     `rw [show ... from NatTrans.naturality_apply ...]` packaging
     pattern, and the fully-explicit-`change`-on-both-sides rule.
     Should these be elevated from "iter-NOTE" annotations in the
     chapter to first-class recipe steps before the d_app prover lane
     dispatches?
2. **Sync_leanok mis-mark count is now 3** (L406 + L524 + L1152). Should
   the iter-143 planner consider a blueprint-writer pass to strip the
   `\leanok` from these three proof blocks, OR is this purely a
   `sync_leanok`-phase concern that the planner should defer to
   `archon-lean4:doctor`? Per CLAUDE.md the `\leanok` is
   `sync_leanok`-deterministic and out of agent scope; flagging here
   only because the count is growing.
3. **Stale `\notready` carry-over from iter-142 informational**:
   `Jacobian.tex:389` (`def:genusZeroWitness`) and `Jacobian.tex:424`
   (`def:positiveGenusWitness`) carry `\notready` markers despite
   their underlying Lean declarations being scaffolded (sorry-bodied).
   Should iter-143 strip these?
4. **Lean-auditor MAJOR on `letI = isIso_of_app_iso_module ... (fun _ => sorry)`
   propagation pattern** — does this affect the blueprint's IsIso
   recipe? The blueprint currently treats Route (b'2) as a per-open
   construction; the auditor's recommendation would refactor the
   in-Lean shape to a named theorem. Is the chapter prose's recipe
   compatible with both shapes, or does it presuppose the `letI`-form?

## Prior critique status

Iter-142 blueprint-reviewer: **PASS / HARD GATE GREEN-LIT on `Cotangent/GrpObj.lean`**.
11 chapters audited; 0 must-fix; 1 soon (carry-over sync_leanok
mis-mark, not blocking); 2 informational (stale `\notready` on the
two `Jacobian.tex` definitions). All iter-141 Wave 3 expansion
landed substantively; iter-142 prover-ready recipes for all three
sub-pieces.

Status of those carry-overs entering iter-143:
- **Carry-over 1** (sync_leanok mis-mark) — still live; count now 3
  per iter-142 lean-vs-blueprint-checker.
- **Carry-over 2** (stale `\notready` on the two `Jacobian.tex` defs)
  — still live.

Please re-audit the whole blueprint and surface any new must-fix-this-iter
or soon-severity findings, and report per-chapter completeness + correctness.
The HARD GATE this iter is on `Cotangent/GrpObj.lean` (planner's intended
target if iter-143 dispatches a prover).
