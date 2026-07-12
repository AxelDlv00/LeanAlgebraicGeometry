# Session handoff — 2026-07-12 (interactive Fable session, post run-0030 recovery)

For the next agent continuing the `rebuild` task on
`MainProjects/Algebraic-Jacobian-Challenge-Rebuild`. Read this first, then
`informal/c1-etale-separatedness-assembly.md` (the binding technical worksheet), then
`informal/wave3-picard-design.md` (the Wave-3 design, still binding).

## Operating model (user's standing instructions)

- **Budget discipline**: the user has limited Fable-5 weekly quota. Use the main (Fable)
  loop ONLY for: route/design decisions, spec-writing, verifying delegated work, commits.
  Delegate ALL Lean implementation to subagents on **Opus** (hard proofs) or **Sonnet**
  (recon, blueprint, mechanical work). One detailed spec per brick; specs in this session
  produced 6/6 green bricks — the pattern works. Include in every spec: exact
  deliverable signatures, files to READ FIRST, proof-route sketch, verification protocol,
  fallback instructions, "final message" format.
- **Verification is non-negotiable**: every brick must be kernel-green (`lake build` of
  the target AND `lake build AlgebraicJacobian`) and axiom-clean
  (propext, Classical.choice, Quot.sound). Independently spot-verify agents' claims
  before committing (root build tail + `lean_verify`).
- **Commit per brick** via `/home/Axel/.local/bin/horizon commit -m "<math-first message>" <files>`
  run from the workspace root `/home/Axel/LeanAlgebraicGeometry-Horizon`. Math-first
  messages. Also `horizon task comment rebuild --author horizon --body ...` at milestones.
- Files ≤ 500 lines, mathlib conventions, no weakening of frozen `Challenge.lean`
  signatures. Blueprint nodes for landed bricks (delegable to a Sonnet blueprint agent).

## What landed 2026-07-12 (all committed, kernel-green, axiom-clean)

| Commit | Brick | Content |
|---|---|---|
| `f3870f6f` | β | `Algebra/LocalizationCocycleBaseChange.lean` — cover-cocycle base change, `cocycleUnit_baseChange`, `pic_baseChange` |
| `5ff3b2e0` | γ | `Picard/CechPicToPicNaturality.lean` — `CechPic.toPic_map` (dictionary natural in the affine scheme) |
| `d5b97f5e` | ε2 | `Descent/UnitDescentComposite.lean` — descent in stages: `tensorCollapse`, `descendedCollapseEquiv`, `picClass_collapse` |
| `c8cf6ad2` | ε1 | `Picard/ProjectionUnits.lean` — `unitsSndEquiv` + naturality in open and test object |
| `20d602eb` | ζ1 | `Picard/EtaleSeparatedness.lean` — `cechPicMap_tensorInl_eq_tensorInr` (coherence seed) |
| `8480851f` | — | Blueprint nodes for run-0030's bricks (UnitDescentBaseChange, AffineTwoCover) |
| `06942ede`,`661357ba` | — | Assembly worksheet + ζ2 redesign |

With run 0030's α (`Descent/UnitDescentBaseChange.lean`) and δ (`Picard/AffineTwoCover.lean`),
the **dictionary-naturality campaign is complete** and the (C1) "genuinely delicate step"
is dissolved into landed theorems.

## IN FLIGHT AT HANDOFF — CHECK FIRST

An Opus agent was building **ζ2·P (Amitsur toolkit)** when this session ended: additions
to `Picard/EtaleSeparatedness.lean` and/or a new `Picard/AmitsurCochain.lean` —
(P1) `exists_global_unit_of_compatible` (∂-trivial unit 0-cochain glues to a global unit),
(P2a) `tensorFace₁₂/₁₃/₂₃ : B ⊗[A] B →ₐ[k] B ⊗[A] (B ⊗[A] B)` + coincidence lemmas of the
six face∘inl/inr composites, (P2b) global-units descent along the projection at `V = ⊤`
+ naturality along `overSpecMap`.
**First action of the next session**: check the workspace ledger status
(`git --git-dir=.archon-horizon/vcs/workspace.git --work-tree=. status --porcelain -- MainProjects/Algebraic-Jacobian-Challenge-Rebuild`)
for uncommitted changes to those files; if present, verify (root `lake build` + `lean_verify`
on the new declarations) and either commit or repair. If absent, re-launch ζ2·P from the
spec in the worksheet (ζ2·P section).

## Next bricks, in order (route fully designed in the worksheet)

1. **ζ2·i (coherent witness)** — the global-unit-correction argument. All ingredients
   land with ζ2·P. Needs a careful spec (Fable) but the math is pinned in the worksheet.
2. **ζ2·ii (pi-assembly)** — components `v_{ij} ∈ (S_i ⊗[𝔄] S_j)ˣ`, `IsDescentCocycle v`,
   `collapse v = cocycleUnit c`. Pure algebra + section rings (LocalizationCocycle style).
3. **ζ3 (close)** — `M := cechPicEquivPic.symm (picClass v)`, prove `p_A^* M = L`
   (design note: arrange the construction so the equality is by-construction-cohomologous;
   the a-posteriori route needs the kernel argument — decide at spec time), then unfold to
   **`PicEtAff.unit_injective`** = (C1), Kleiman 2.5(1). Blueprint nodes + I-0140 update.
4. After (C1): Layer-2 `PicEt` (gated exactly on (C1)'s sheaf-on-affines corollary —
   see inbox I-0140 and design OPEN-1), then (C2) rigidification statement, degree/Pic⁰
   interface (§6), then Wave 4 (`jacobianData` — the representability wall; the old
   draft's verified `FlatteningStratification`/`GradedHilbertSerre`/`IdentityComponent`
   are the reusable *lessons*, code must be rewritten).

## Operational gotchas (hard-won today)

- `lake env lean` scratch files for `#print axioms` get **OOM-killed** on this box under
  load. Use the lean-lsp MCP `lean_verify` tool instead (live server, reliable).
- Opus agents repeatedly fell into "wait on a background build monitor" and stopped
  without reporting. Every spec must say: verification in the FOREGROUND, block on it.
  If an agent stops early anyway, resume it via SendMessage with "finish verification in
  foreground now".
- `grep -c sorry file` exits 1 on zero matches — don't chain it with `&&`.
- Parallel agents editing `AlgebraicJacobian.lean` (import list) works; every spec must
  include the "on staleness re-read and re-apply just your line" clause.
- `horizon commit` / `task comment` must run with cwd inside the workspace.
- Old-draft audit correction (for planning): the old project has only **24 real sorries
  in 11 files** (the "40 files" figure was doc-comment noise); both projects have
  discharged only `genus` among the frozen targets; the old draft never attempted the
  functor/base-change targets. Full audit in this session's transcript
  (`.archon-horizon/` run dirs) and summarized in the task comments.

## Key API map (for spec-writing)

- Dictionary: `cechPicEquivPic`, `CechPic.toPic`, `toPic_mk`, `toPic_injective/surjective`
  (`Picard/CechPicToPic*.lean`); naturality `toPic_map`/`toPic_mapAlgebra`.
- relPic quotient: `relPicMk_eq_relPicMk_iff`, `mem_picFromBase_iff` (on-the-nose
  equation shape), `relPicMap_mk` (`Picard/RelPic.lean`).
- Plus construction: `PicEtAff.unit`, `mk_eq_mk_iff`, `descentClasses`,
  `relPicAlgMap_congr` (`Picard/PicEtAff.lean`); `Algebra.EtaleCover` has
  `Module.FaithfullyFlat A E.Carrier` as an instance.
- Descent: `IsDescentCocycle` (faces in `B ⊗[A] (B ⊗[A] B)` shape), `picClass`,
  `picClass_eq_one_iff`, `descentCoboundary` (`Descent/UnitDescent.lean`);
  stages: `descendedCollapseEquiv`, `picClass_collapse` (`Descent/UnitDescentComposite.lean`).
- Projection descent: `unitsSndEquiv` + naturality (`Picard/ProjectionUnits.lean`);
  brick 3 `prPullback_injective` (`Picard/Separatedness.lean`).
- Cover cocycles: `LocalizationCocycle*.lean` (pi-ext everywhere), basic refinements +
  choice-independence calculus (`PicAffineCover.lean`, `PicAffine.lean`).
