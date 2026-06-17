# Progress-critic directive — iter-038

Assess convergence of the single active route. No strategy/blueprint context is given by design — judge convergence only.

## Active route: 01I8 `F ≅ ~(ΓF)` via section-localization (Route B)

This is the sole active prover route. It computes the keystone
`IsLocalizedModule (.powers f) (Γ(Spec R, F) → Γ(D(f), F))` for quasi-coherent `F`,
via a `\uses`-linked sub-lemma chain B0–B6. The keystone unblocks 02KG/02KE tops downstream.

The route entered its current phase (section-localization / Route B, the B0–B6 chain) at **iter-036**.
Strategy `Iters left` estimate for this route: **~2–4**.

### Last 5 iters' signals (K=5, iters 033–037)

Project total `sorry` count: **2 every iter, unchanged** (both frozen/superseded — `CechAcyclic.affine`
dead + a frozen P5b target). All lanes are `mathlib-build` mode (no-sorry invariant: each step either
fully proved or left absent). So "sorry count" is NOT the convergence signal here; named-target /
sub-lemma closures and helper accumulation are.

| iter | files worked | axiom-clean decls added | named/sub-lemma closures | prover status | recurring blocker phrase |
|---|---|---|---|---|---|
| 033 | TildeExactness (predecessor route P) | germ-naturality crux + reduction | partial | PARTIAL | σ_x R-linearity packaging |
| 034 | AffineSerreVanishing + TildeExactness | +4 (02KG cover-system) / +2 | 02KG cover-system complete; tilde partial | PARTIAL | tilde germ-naturality / jointly-reflecting assembly |
| 035 | QcohRestrictBasicOpen (new) + TildeExactness | +5 / +4 | P1a L1 both named targets (`modulesRestrictBasicOpen`+Iso) | DELIVERED + PARTIAL | `.over→affine` base-change bridge absent in Mathlib |
| 036 | QcohTildeSections (Route B pivot) | +3 local-model bricks | 3 bricks; keystone left ABSENT | DELIVERED (keystone absent) | `.over→affine` base-change bridge (SAME wall) |
| 037 | QcohRestrictBasicOpen + QcohTildeSections | +5 / +2 | **B1 + B2 named targets CLOSED** (first named closures in this phase); B3 blocked | DELIVERED (B3 absent) | B3 structure-sheaf compat datum `φ/ψ/H₁/H₂` |

Context for the read:
- iter-036 was flagged CHURNING by the prior progress-critic (named keystone absent ×5 iters). The
  iter-037 plan responded with a **structural corrective** (NOT another helper round): a mathlib-analogist
  consult decomposed the keystone into the B0–B6 chain, the blueprint was rewritten, and the two leaf
  sub-lemmas B1 + B2 were split into independent lanes and **both closed** that iter.
- The blocker phrase changed from "`.over→affine` base-change bridge" (a vague deep wall, iters 035–036)
  to the precisely-located "B3 structure-sheaf compat `φ/ψ/H₁/H₂` via `(specBasicOpen g).ι.appIso`"
  (iter-037), with B3 itself now decomposed into B3a/B3b/B3c by the prover.
- B0–B6 status entering iter-038: B0 [done], **B1 [done iter-037]**, **B2 [done iter-037]**,
  B3 [blocked — the single load-bearing bridge, decomposed B3a/b/c], B4 [mechanical, gated on B3],
  B5/B6 [done consumers]. After B3+B4 land, one keystone-assembly step remains, then route-level assembly.

### This iter's proposed objective (1 file)

1. `QcohRestrictBasicOpen.lean` — build **B3** `overBasicOpenIsoRestrict` (the bridge, via B3a/B3b/B3c)
   + **B4** `presentationModulesRestrictBasicOpen` (mechanical after B3). `mathlib-build` mode.

Only one prover lane: B1 is done so the QcohTildeSections keystone-assembly lane is genuinely blocked
on B3/B4 (cannot import them until they exist) — there is no honest second lane this iter.

## Question

Is Route B CONVERGING, or is the B-chain decomposition just a renamed continuation of the same churn
(helpers accumulating, residual not shrinking)? Specifically: does closing B1+B2 and isolating B3 to a
single precisely-decomposed bridge constitute genuine convergence, or is B3 the same `.over→affine` wall
under a new name with no real progress? Give a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR)
and, if not CONVERGING, the corrective TYPE.
