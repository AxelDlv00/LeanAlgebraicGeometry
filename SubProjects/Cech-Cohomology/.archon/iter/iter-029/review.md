# iter-029 review

## Overall progress this iter
- **Total sorry**: 2 → 2 (no regression). Both intentional/frozen: superseded relative-form
  `CechAcyclic.lean:110` (`affine`) + frozen P5b `CechHigherDirectImage.lean:679`. Both new files 0 sorry.
- **Build**: GREEN. `AffineSerreVanishing.lean` + `QcohTildeSections.lean` both `lake env lean … EXIT 0`,
  diagnostic-clean, all 7 new decls `lean_verify`-clean (`{propext, Classical.choice, Quot.sound}`). **Neither
  imported into root yet.**
- **Lanes planned 2, ran 2** (both `mathlib-build`, "build as far as possible"). **+7 axiom-clean decls** (3+4).
- `archon dag-query`: **gaps = 0**, **unmatched = 5** (1 dead superseded decl + 4 new helpers).

## The headline: the first iter that stopped on real mathematics, cleanly
Five consecutive prior iters were first-attempt-COMPLETE. This iter the 02KG affine phase reached the parts
that need geometry Mathlib does not ship, and BOTH lanes stopped short of their named targets — on genuine
gaps, not tactic failures. The `mathlib-build` no-sorry invariant did exactly what it is for: no sorries, clean
handoffs with the precise next ingredient named. The +7 decls are solid infrastructure (cover-system fields +
the conditional affine structure theorem); the residual is honest, not churn.

- **Lane 1 `AffineSerreVanishing.lean`** (+3): `affine_faces_mem`, `coverOpen_affineOpenCoverOfSpan` (open-level
  cover bridge), `affine_injective_acyclic` (⊤-cover case). Blocked: `standard_cover_cofinal`,
  `affine_surj_of_vanishing`, `affineCoverSystem` — all need new geometry (cofinality of standard covers;
  sheaf-epi local section surjectivity) plus a relativized `injective_cech_acyclic`.
- **Lane 2 `QcohTildeSections.lean`** (+4): `qcoh_iso_tilde_sections` (conditional `[IsIso F.fromTildeΓ]` form)
  + presentation form + 2 `@[simp]` accessors. Unconditional qcoh form blocked on one instance
  `[IsQuasicoherent F] → IsIso F.fromTildeΓ` (Stacks 01I8 affine global generation, ~few-hundred LOC).

## This iter's analysis
- **Honest partial progress, correctly bounded.** Both lanes' Lean is genuine and axiom-clean (lean-auditor:
  0 critical; lvb ×2: 0 Lean red flags). The scope restrictions are disclosed in docstrings AND now in
  blueprint `% NOTE:`s. No weakening, no vacuity, no excuse-comments.
- **The load-bearing finding is a DESIGN FORK, surfaced by both the prover and lvb-affine.**
  `BasisCovSystem.injective_acyclic`/`surj_of_vanishing` quantify over covers of arbitrary `D(f)` (the L4
  induction hits the *faces* `⨅ₖ c.2(σk)` = sub-`D(f)`s), but the landed `affine_injective_acyclic` only
  covers `⊤`. Closing this needs a **relativized `injective_cech_acyclic` over an arbitrary open `W`** (resolve
  `freeYoneda W` in CechBridge/FreePresheafComplex), which is a change to files *outside* `AffineSerreVanishing.lean`.
  The planner must make this a STRATEGY decision before re-dispatching `affineCoverSystem`. Recorded CRITICAL in
  recommendations + `% NOTE:`s on `lem:affine_injective_acyclic` and `def:affine_cover_system`.
- **Lane 2's gap is the project's long-known "one genuine gap" (01I8), now precisely located.** The conditional
  + presentation forms mean the qcoh upgrade is mechanical the instant the global-generation theorem lands. The
  blueprint already documented this gap (prose L580–592); the file's `## Handoff` adds a 3-step decomposition.

## Markers / coverage
- **Manual `% NOTE:` edits (4)**: `lem:qcoh_iso_tilde_sections` (conditional-form divergence),
  `lem:cover_datum_bridge` (dangling pin, open-level half only), `lem:affine_injective_acyclic` (⊤-scope
  overclaim), `def:affine_cover_system` (not-yet-buildable). No `\leanok` touched (sync iter=29: +6/−5). No
  `\mathlibok` (all new decls are project-local packagings, not re-exports). No `\notready` stripped.
- **Coverage debt = 5 unmatched** (listed in recommendations): `coverOpen_affineOpenCoverOfSpan`,
  `qcoh_iso_tilde_sections_of_presentation` (deserves own block), `_hom`/`_inv` (bundle), and the dead
  `CechAcyclic.affine` (sorry, de-pinned this iter — recommend deletion to drop sorry 2→1).
- blueprint-doctor: clean. sync_leanok ran for iter 29 (sha 8895ee2) — `\leanok` state is authoritative.

## Audits
- lean-auditor `iter029`: 0 critical / 2 major (both = orphaned-from-root, known) / 3 minor (`import Mathlib`
  narrowing; `change`-fragility). Report: `task_results/lean-auditor-iter029.md`.
- lvb `affine-iter029`: 0 Lean red flags / 2 major (dangling pin + ⊤-scope overclaim → both NOTEd).
- lvb `qcoh-iter029`: 0 must-fix-this-iter / 3 major (coverage + proof-prose mismatch) / 2 minor; conditional
  decl axiom-clean, `\leanok` correctly on the conditional decl.

## Frontier ahead
The 02KG affine phase is now decomposed down to its two real seams: (a) the ⊤-vs-`D(f)` relativization of
`injective_cech_acyclic` + standard-cover cofinality + sheaf-epi local surjectivity (cover-system half), and
(b) the 01I8 affine global-generation theorem (tilde-globalisation half). Both are genuine mathematics with no
Mathlib shortcut. After those: `affine_cech_vanishing_qcoh` + `affine_serre_vanishing` assembly → P5a → the
frozen P5b assembly (+ the ~6-LOC `EnoughInjectives` connector recorded last iter). The planner should expect
1–2 real iters per seam, not first-attempt closes.

## Subagent skips
- (none — both highly-recommended review subagents ran: lean-auditor + lean-vs-blueprint-checker ×2, one per
  prover-touched file.)
