# Blueprint Reviewer Directive

## Slug
iter272

## Strategy snapshot

Goal: formalize Christian Merten's Jacobian challenge — the nine protected
declarations headed by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness`: an Albanese/Jacobian object uniform over the
`k`-rational pointing of a smooth proper geometrically irreducible curve `C/k`
(`[Field k]` only). `J := Pic⁰_{C/k}` built unconditionally; `isAlbaneseFor`
quantified over the pointing. End-state: zero inline `sorry` in each protected
decl's cone. Posture **option (c)**: forward the Route-A Picard substrate while
Riemann–Roch stays frozen by the permanent USER Route-C pause.

### Phases & estimations

| Phase | Status | Iters left | Key Mathlib needs |
|---|---|---|---|
| A.1.c.sub — comparison iso on line bundles (loc-triv) | ACTIVE (D3′ + dual route-2 poles) | ~18–30 | composite-adjunction unit-cocycle; isIso_of_isIso_restrict; ε-naturality |
| A.1.c.fun — RelPic functor on IsLocallyTrivial | OPENING | ~7–12 | CommGroup→AddCommGroup transport; ét-topology on Over S |
| A.2.c — representability scaffolding | HELD behind A.1.c | ~12–16 | A.1.c |
| A.2.c-engine — Quot/Cartier (RR-free, Rⁱf_* Čech) | OPEN, dominant pole | ~85–140 | Rⁱf_*, Rel Proj, CM-regularity, flattening |
| A.3 — tangent + Pic⁰ AV-structure | gated A.2.c | ~26–45 | scheme tangent space; Hilbert poly |
| A.4 — Albanese UP (Route 1 RR-free primary) | gated A.2.c | ~12–20 | Milne 3.2/3.10 rigidity + rational-map extension |
| genusZero + witness body | gated A.3 | ~5–7 | tangent-iso + connectedness |
| Route C — Riemann–Roch | PAUSED (USER, permanent) | — | off the critical path |

## Routes

`J := Pic⁰_{C/k}`. Critical path (RR-free): A.1.c.sub → A.1.c.fun → A.2.c.
- Route A (PRIMARY): FGA Picard representability engine + Albanese UP via Weil's
  divisor-sum map, rigidity (Milne 3.2/3.10, RR-free), rational-map extension.
- Route C (Riemann–Roch): PAUSED permanently — its chapters
  (`RiemannRoch_*`) carry inline sorries and are NOT on the goal's critical
  path. Treat RR chapters as frozen: do not flag their internal incompleteness
  as must-fix, but DO report whether any active-route (Route-A) cone
  transitively `\uses{}` a paused RR declaration (a disjointness violation —
  strategy-modifying).

## Primary concern this iteration: 1-to-1 coverage debt

The prover loop (iters 271–272) generated **~427 Lean helper declarations with
no blueprint entry** (`leandag` lean-aux nodes; `archon dag-query unmatched`).
The blueprint is therefore NOT 1-to-1 complete (gate criterion 5 fails). The
heaviest uncovered clusters by source file:

- `Picard/TensorObjSubstrate.lean` (40) + `TensorObjSubstrate/PresheafInternalHom` (32)
  + `TensorObjSubstrate/StalkTensor` (24) + `TensorObjSubstrate/DualInverse` (14)
  + `TensorObjSubstrate/Vestigial` (13) — chapter `Picard_TensorObjSubstrate.tex`
- `RiemannRoch/WeilDivisor.lean` (32) — PAUSED route
- `Picard/TensorObjSubstrate/PresheafInternalHom.lean` (32)
- `Albanese/AuslanderBuchsbaum.lean` (31)
- `Albanese/CodimOneExtension.lean` (30)
- `Genus0BaseObjects/Points.lean` (25) — **NO CHAPTER EXISTS**
- `Picard/FGAPicRepresentability.lean` (16)
- `RiemannRoch/OCofP.lean` (14) — PAUSED route
- `Genus0BaseObjects/ChartIso.lean` (14) — **NO CHAPTER EXISTS**
- `Genus0BaseObjects/BareScheme.lean` (11) — **NO CHAPTER EXISTS**
- `Genus0BaseObjects/GmScaling.lean` (8) — **NO CHAPTER EXISTS**
- `Genus0BaseObjects.lean` (root) — **NO CHAPTER EXISTS**

For each chapter, tell me in the per-chapter checklist whether it adequately
covers its Lean file's declarations, and which uncovered helpers genuinely need
a blueprint entry (real mathematical content) versus pure plumbing
(structure projections, `_apply` simp lemmas, instances) that can take a
one-line "proved directly in Lean" entry.

**Treat the missing Genus0BaseObjects chapters (Points, ChartIso, BareScheme,
GmScaling, and the root `Genus0BaseObjects.lean`) as unstarted-phase proposals:
produce a concrete chapter outline for each** so I can dispatch a
blueprint-writer immediately. These files back the genus-0 base objects
(`ℙ¹`-bar / `𝔾_a` / `𝔾_m` schemes, chart isos, scaling action, k-points) used by
the genus-zero arm of the witness construction.

## References
- `references/challenge.lean.ref` — authoritative protected signatures.
- `references/kleiman-picard.md`, `references/nitsure-hilbert-quot.md` — Route-A engine.
- `references/abelian-varieties.md` (Milne) — rigidity 3.2/3.10, Albanese UP.
- `references/stacks-*.md` — cohomology/algebra/relative-spec substrate.

## Focus areas
- The five `Picard/TensorObjSubstrate*` files vs `Picard_TensorObjSubstrate.tex`:
  is the chapter covering the whole sub-file family, or only the root file?
- The Genus0BaseObjects sub-files with no chapter (structural coverage hole).
- Active-route vs paused-route disjointness (Route-A cone must not pull a paused
  RR decl).

## Known issues
- The 3 isolated blueprint nodes (`lem:S3_sep_2_*`, `lem:S3_pi_2_*`,
  `lem:isiso_sheafification_map_of_W`) are reviewer-certified isolation-EXEMPT
  (descoped / superseded). Do not re-flag unless your read differs.
- `\leanok` sync is deterministic; do not comment on `\leanok` presence/absence.
