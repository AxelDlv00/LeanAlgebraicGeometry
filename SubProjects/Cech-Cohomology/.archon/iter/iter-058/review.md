# iter-058 review

## Overall progress this iter
- **Total sorry:** 10 → **10** (no regression, no closures, **none forced/papered**). This is a
  foundation-building iter: the +11 axiom-clean declarations sit *under* the assembly sorries (Lane 2)
  or close a route whose top had no sorry (Lane 1), so the global count is flat while the frontier moved.
  Open holes unchanged: `CechSectionIdentification:372/422/513/583/642` (Stubs 1,2,4,5,6),
  `CechAugmentedResolution:229`, `OpenImmersionPushforward` (×2), `CechHigherDirectImage:780` (frozen P5b),
  `CechAcyclic:110` (dead).
- **Build:** GREEN. Verified first-hand — `lake env lean` exit 0 on a combined import of both prover
  files; `#print axioms` = `{propext, Classical.choice, Quot.sound}` on `affine_serre_vanishing_general_open`,
  `coproduct_fibrePower_reindex`, `prodFinSuccIso`.
- **Lanes planned 2, ran 2.** Lane 1 SOLVED; Lane 2 PARTIAL-with-major-progress. **+11 axiom-clean decls.**
- **dag-query:** gaps = 0; unmatched = 9 (6 new + 2 older carry-over + dead `affine`). `sync_leanok` ran
  iter-058 (sha `d409ec0`, +7/−5). **blueprint-doctor:** no findings.

## Headline 1 — Need #2 CLOSED end-to-end (general-affine-open Serre vanishing)
`affine_serre_vanishing_general_open` is now an unconditional `Ext^p = 0` theorem, axiom-clean. This was
the planner's Lane 1 (D3): a short consumer wiring of the iter-057 seed
`sectionCech_homology_exact_of_affineOpen`. It landed exactly as scoped — private
`affine_tildeVanishing_general` (mirror of `affine_tildeVanishing`, seed/hyp swap) + a one-line
composition with the existing reduction. The flagged `Algebra Γ(V) Γ(D a)` instance trap did not recur
(absorbed in the seed). The general-affine-open route the project pivoted to in iter-056 (ambient
cover-system enlargement, NOT the restriction-of-injectives `j_!` wall) is now complete and is the
foundation under Need #1's open-immersion acyclicity.

## Headline 2 — Stub-1 backbone: all bricks built, decomposition converged
Lane 2 built the **4 blueprint-named decomposed leaves** of `lem:coproduct_distrib_fibrePower` plus
`prodFinSuccIso` (confirmed Mathlib gap) and 4 `Over S` (co)product helpers — 9 axiom-clean decls. Per
the prover, **every categorical brick the inductive step needs now exists**; the lone remaining piece is
assembly glue (`overProd_coproduct_distrib` + the induction wiring, ~80–150 LOC). The prover did NOT
stub the induction — `cechBackbone_left_sigma` keeps its honest pre-existing sorry. This is the payoff
of the planner's D1 decision (effort-break before re-throwing the monolith): the iter-057 CHURNING route
is now demonstrably converging.

## Soundness — confirmed three ways, no papering
- Review first-hand: combined build green + `#print axioms` clean on 3 keystones.
- **lean-auditor `iter058`** (0 critical / 2 major / 9 minor): AffineSerreVanishing clean; all 5 CSI
  sorries honest; Stubs 5/6 correctly re-signed to the augmented `D'_aug` form (the iter-056 concern is
  fully resolved). The 2 majors are both forward-looking, not breakage (universe trap + an upstream
  `IsScalarTower` note).
- **lvb `affineserre`** (0 red flags) + **lvb `csi`** (0 must-fix): the new decls match their blueprint
  labels; the 5 sorries are correctly typed.

## The two MAJOR follow-ups (neither is a wall)
1. **Universe trap (auditor, `.lean`):** `prod_coproduct_distrib` / `coproduct_fibrePower_reindex` are
   `{ι : Type}` not `{ι : Type*}` — will silently block the Stub-1 induction at `ι = 𝒰.I₀ : Type u`.
   Trivial fix; must precede the next CSI prover round.
2. **σ-normal-form divergence (lvb-csi, blueprint):** Lean uses the slice-product form `∏ᶜ Over.mk (f∘σ)`,
   blueprint prose writes `X_{σ(0)}`. Needs a bridge note (blueprint-writer) before the next CSI gate.

Both are recorded in `recommendations.md` (#1, #2) for the next plan agent.

## Markers I changed
Stripped 4 stale `% NOTE: build target` comments in `Cohomology_CechHigherDirectImage.tex` on the 4
now-landed leaves (`lem:widePullback_overX_eq_prod`, `lem:coproduct_distrib_fibrePower_zero`,
`lem:prod_coproduct_distrib`, `lem:coproduct_fibrePower_reindex`); kept the NOTE on the still-unbuilt
`lem:coproduct_distrib_fibrePower` and the augmented-form / Route-3 NOTEs. No `\mathlibok`, no `\lean{}`
renames, no `\notready` to strip.

## Process note
Clean iter. The planner's decompose-before-prover response to the iter-057 CHURNING verdicts paid off:
Lane 1 closed its objective and Lane 2's decomposition is now visibly converging (bricks done, only glue
left). No new RED build, no fabricated sorries, no monolith re-throw.
