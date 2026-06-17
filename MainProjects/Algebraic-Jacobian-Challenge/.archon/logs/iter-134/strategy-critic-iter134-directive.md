# Strategy Critic Directive

## Slug
iter134

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen. The challenge file's `nonempty_jacobianWitness`
quantifies over an arbitrary curve `C : Over (Spec (.of k))` with
`[SmoothOfRelativeDimension 1 C.hom]` — no genus parameter, no `k`-rational-point
hypothesis. The project must produce ZERO inline `sorry` and NO named axioms.

## Strategy under review

The current `STRATEGY.md` is at `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`.
Read it verbatim from disk.

## References index

```
| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

## Blueprint summary

| Chapter | Topic |
|---|---|
| `AbelJacobi.tex` | Abel–Jacobi map `α_P : C → Jac(C)`; closed via Albanese universal-property projection from `nonempty_jacobianWitness`. |
| `Cohomology_MayerVietoris.tex` | Mayer–Vietoris LES for sheaf cohomology with k-module coefficients; Čech-acyclicity engine for Serre finiteness. |
| `Cohomology_SheafCompose.tex` | Sheaf-condition transport along `CommRing → Ring → Ab`; Phase A step 1. |
| `Cohomology_StructureSheafAb.tex` | Sheafification + Ext for Ab-valued sheaves on opens; `O_C` as Ab-sheaf; Phase A steps 2–4. |
| `Cohomology_StructureSheafModuleK.tex` | Sheafification + Ext for k-module-valued sheaves; `O_C` as k-module-sheaf; Phase A step 5. |
| `Differentials.tex` | Relative cotangent presheaf `Ω_{X/S}`; smoothness forward direction. M1 bridge EXCISED iter-126; standalone K-localization utilities + M1.d Mathlib-PR candidate preserved. |
| `Genus.tex` | `genus C = finrank_k H^1(C, O_C)` via Serre finiteness. |
| `Jacobian.tex` | `JacobianWitness`, `Jacobian.ofCurve`, `nonempty_jacobianWitness` genus-stratified body (genus-0 `genusZeroWitness` → M2; positive `positiveGenusWitness` → M3); soft drift in C.2.a–C.2.e (over-`k̄` historical scaffolding) deferred iter-134+ informational cleanup. |
| `Rigidity.tex` | `Scheme.Over.ext_of_eqOnOpen` (the over-k extension uniqueness lemma; closed iter-125). |
| `RigidityKbar.tex` | Over-k rigidity `rigidity_over_kbar` (k-agnostic signature post iter-126); body gated on shared cotangent-vanishing pile (i)+(ii)+(iii). § Piece (i.a) is the `GrpObj.cotangentSpaceAtIdentity` + `…_finrank_eq` declarations (DONE iter-132). § Piece (i.b) is `mulRight_globalises_cotangent`: iter-133 blueprint-writer hardened the chapter with the full Lean signature stub, 3-step proof prose, 2 helper sub-lemmas (`lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_restrict_to_identity_section`), MED-B `lem:GrpObj_cotangentSpace_extendScalars_witness`, MED-C rewrite-pattern paragraph; 324 → 511 LOC. |

Note: `Cotangent/GrpObj.lean` does NOT have a dedicated `Cotangent_GrpObj.tex` chapter; the project's piece (i) cotangent infrastructure lives in `RigidityKbar.tex` § Piece (i.a)/(i.b)/(i.c).

## Prior critique status

You (strategy-critic) were dispatched iter-133 as `strategy-critic-iter133` and returned SOUND with 3 minor-to-major CHALLENGEs + 2 minor schedule-advance recommendations, all of which the iter-133 plan agent ABSORBED via 5 substantive STRATEGY.md edits (verbatim in `iter/iter-133/plan.md § "STRATEGY.md edits this iter"`):

1. **§ "Over-k re-defense on revised numbers"** — ground (iv) REINSTATED scope-narrow as iter-132 **piece (i.a)** tractability evidence (NOT iter-131; NOT whole-pile validation). Re-open criterion: any subsequent over-k pile piece slipping > 50% above iter-131-revised estimate.
2. **§ "Fibre-free piece (i) reformulation"** — 4-axis scorecard (LOC + canonicity + blueprint alignment + downstream API shape) replaces the iter-132 1-axis criterion. Decision: STAY ON Replacement (B); pivot trigger preserved.
3. **§ "Gap (scheme-level absolute Frobenius)" + § "C(k) ≠ ∅ branch ℙ¹-specific rigidity hedge"** — both schedule-advanced iter-140+ → **iter-135–138** (verdict feeds piece (i.c) iter-137+ and piece (ii) iter-141+).
4. **§ Sequencing table** — piece (i.a) marked DONE iter-132 (empirical ~300 LOC); iter-133 row added; piece (i.b) envelope refined to **210–440 LOC** under sheaf-level RHS; piece (i.c) inflated 100–300 → 200–500 LOC (chart-localisation identification pushed in from piece (i.b)).
5. **§ "Direct over-k rigidity"** — new "iter-133 resolution of iter-130 strategy-critic Q2" sub-section explaining how the iter-133 mathlib-analogist's sheaf-level RHS recommendation refutes the iter-130 (B)→(A) bridge worry; **§ "Mathlib gap inventory"** — 2 new entries for piece-(i.b) sub-pieces (shear iso ~30–60 LOC + base-change-of-differentials ~150–300 LOC).
6. Trigger (a') refinement: fires only on value-level-stalk RHS choice; watchpoint added for iter-134+ slip > 2 iter beyond envelope.

**The iter-133 plan agent's stated request to you for iter-134**: re-verify that the 5 STRATEGY.md edits absorbed correctly. Pay particular attention to:

- The scope-narrow framing of ground (iv) ("piece (i.a) tractability evidence"). Flag any silent upgrade to whole-path validation as a fresh CHALLENGE.
- The 4-axis scorecard for fibre-free piece (i) reformulation — is the decision matrix honest, and does the pivot trigger remain testable?
- The iter-135–138 advance for the ℙ¹-hedge + higher-Kähler-vanishing analogist consults — are these correctly sequenced ahead of piece (i.c)+(ii)+(iii)?
- The sequencing table's piece (i.a) "DONE iter-132 / ~300 LOC empirical midpoint" — is this honest reporting (NOT a celebration that crowds out the iter-128→iter-131 corrective-iter overhead)?
- The watchpoint on iter-134+ piece (i.b) envelope — is "> 2 iter slip beyond 2–4 iter / 210–440 LOC" a meaningful trigger, or is it set so high it can't fire?

Additionally, treat any of the following as fresh CHALLENGE candidates if you spot them:

- The over-k commitment's load-bearing claim that pieces (i)+(ii)+(iii) build directly over an arbitrary base field k (see § "Direct over-k rigidity" and `analogies/cotangent-vanishing-pile-over-k.md`); does the piece (i.b) sheaf-level RHS recommendation introduce any over-k vs over-`k̄` re-coupling not yet documented?
- The piece (i.b) closure chain (a)+(b)+(c)+(d) per the iter-133 mathlib-analogist: are any of the 2 NEEDS_MATHLIB_GAP_FILL sub-pieces (shear iso, base-change-of-differentials) under-scoped relative to actual Mathlib (e.g., `KaehlerDifferential.tensorKaehlerEquiv` exists but with what assumptions)?
- The DEFERRED items (piece (iv) Serre duality 3000–8000 LOC; M3 Picard/Sym^n routes 6500/9000 LOC user-escalation pending). Is the iter-133 plan agent's deferral discipline still sound, or is the project quietly accumulating a back-log that the over-k commitment can't pay off?

If the strategy is sound as-is, return SOUND. If you have CHALLENGEs, name them precisely with reference to which STRATEGY.md section and what alternative the planner should consider.
