# Lean vs blueprint check — Points (gm_grpObj) iter-181

## File

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects/Points.lean`

## Chapter

The `gm_grpObj` instance is documented in the consolidated chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`
under `def:gm_grpObj` (look for the `\lean{AlgebraicGeometry.gm_grpObj}`
pin near L1037). The chapter declares `covers:` for several
Genus0BaseObjects files via the `% archon:covers` macro at top —
verify the cover list includes Points.lean.

## What happened this iter

Lane C prover closed both round-trip identities for `gmHomEquiv`
kernel-clean (per `lean_verify` on each: `{propext, Classical.choice,
Quot.sound}` — kernel-only baseline). `gm_grpObj` instance is now
fully kernel-clean (transitively). File sorry count went 2 → 0.

This is the resolution of an 11-iter `gm_grpObj` STUCK pattern.

## Audit questions

1. Does the chapter's `def:gm_grpObj` block adequately describe the
   construction now landed in Lean (the
   `GrpObj.ofRepresentableBy (Gm kbar) (gmHomFunctor kbar) ...`
   approach)?
2. The two new round-trip identity lemmas `gmHomEquiv_left_inv` and
   `gmHomEquiv_right_inv` — should the blueprint add `\lean{...}`
   pins for them, or are they internal-to-Lean structure?
3. Helpers from iter-180 (`gmHomFunctor`, `gmHomEquiv_toFun`,
   `gmHomEquiv_invFun`, `gmHomEquiv_invFun_isOver`,
   `gmHomEquiv_homEquiv_comp`) — do any need `\lean{...}` pins?
4. The blueprint chapter `% archon:covers` line — does it list
   `Points.lean` correctly (verify via the consolidated-cover mapping)?

## Output

Standard lean-vs-blueprint-checker report. HARD GATE verdict on
the chapter's `complete:` / `correct:` axes.

## Read scope

- The Lean file in full.
- The blueprint chapter in full.
- No other context.
