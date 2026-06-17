# Strategy-critic directive (iter-172)

## Mode

fresh-context strategic audit

## Goal (one paragraph)

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations, headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — the existence of an Albanese / Jacobian
object uniform over the `k`-rational pointing of a smooth proper geometrically
irreducible curve `C/k`, with no `C(k) ≠ ∅` hypothesis. End-state: zero inline
`sorry`, kernel-only axioms. The spine is **pointed vs. unpointed** (object
real on both arms; vacuity touches only the `∀ P` Albanese field for unpointed
`C`). genus-0 rigidity proved over `k̄`, descended to general `k`.

## STRATEGY.md (verbatim — read at `.archon/STRATEGY.md`)

The subagent should `Read /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` directly. (81 LOC, well under context budget.)

## references/summary.md

See `references/summary.md` for the bundle. Project references: Milne *Abelian Varieties* (Rigidity, Cor 1.5, Cor 1.2, Albanese UP); Mumford *Abelian Varieties* (cube — now off-path); Kleiman *Picard Scheme* (Route A); Nitsure *Hilbert/Quot* (Route A.2); Hartshorne *Algebraic Geometry* (RR bridge); Stacks (varieties / fields / commutative algebra / coherent cohomology / constructions); Christian Merten's challenge.lean.

## Blueprint summary (one line per chapter)

- `AbelianVarietyRigidity.tex` (covers AVR.lean, G0BO.lean, RigidityLemma.lean) — Rigidity Lemma + Cor 1.5/1.2 + genus-0 final assembly + supporting `ProjectiveLineBar`/`Gm` infrastructure.
- `Jacobian.tex` — Witness bundle + genus-0 / positive-genus stratification + Route A sub-phase decomposition.
- `Genus.tex` — arithmetic genus definition.
- `RigidityKbar.tex` — `[CharZero]` fallback rigidity over `k̄` (OFF critical path).
- `Rigidity.tex` — `ext_of_eqOnOpen` density bridge.
- `AbelJacobi.tex` — final wrapper.
- `RiemannRoch_WeilDivisor.tex` — RR.1 sub-build (NEW iter-171): Weil divisors on smooth proper curve; 9 declarations pinned (`Scheme.WeilDivisor`, `ofClosedPoint`, `degree`, `degree_hom`, `principal`, `principal_hom`, `principal_degree_zero`, `LinearEquivalence`, `RationalMap.order`).
- `Cohomology_*.tex`, `Differentials.tex`, `AlgebraicJacobian_Cotangent_GrpObj.tex` — `H^1(O_C)` machinery + ancillaries (CLOSED).
- **MISSING**: `Picard_RelativeSpec.tex` (Route A.1.a — blueprint-writer route-a1-decompose dispatched iter-171, original failed, retry killed mid-write before commit; chapter DOES NOT EXIST on disk).

## Live user hints captured this iter

1. **Refactors may decompose large `.lean`/`.tex` files**: `Genus0BaseObjects.lean` (880 LOC) and `Cohomology/StructureSheafModuleK.lean` (877 LOC) flagged. Parallel work would benefit.
2. **"Many objectives have `~0/it`, meaning prover objectives aren't moving the project forward."** STRATEGY.md velocity column has 4 of 9 rows reading `~0/it` (Routes A.1/A.2/A.3/A.4) — that's all of Route A. Rows reading `~80/it` (genus-0 rigidity) and "gated" are the only non-zero rows.
3. **Route A.2 (`~2200-3000 LOC`) needs further decomposition into sub-rows under 1000 LOC each.** Same for genus-0 RR bridge (`~1500-2500 LOC`).

## Asks

1. **Verdict on STRATEGY.md** — SOUND / CHALLENGE / REJECT. Is the 4-row A.1-A.4 + 4-sub-phase RR decomposition adequate per user hint 3, or does it need a finer per-Lean-file split (A.2 into ≥3 files under 1000 LOC each, RR into 4 already-split files)?
2. **Velocity diagnosis** — `~0/it` on all 4 Route A rows for 5 consecutive iters is a strong signal of UNDER_DISPATCH (per iter-171 progress-critic verdict). Is the iter-172 plan to open Lane B + Lane C parallel file-skeleton lanes the right corrective, or should the planner do something more aggressive (e.g. dispatch refactor subagents to pre-split G0BO + StructureSheafModuleK in the same iter Lane A is running)?
3. **Open question status on A.4** — is the Picard-functoriality bypass claim load-bearing or should A.4 row's `Iters left ~7-11 *if* bypass holds` be re-estimated as `~22-30 *otherwise*` to remove the implicit best-case assumption?
4. **Genus-0 row velocity** — `~80/it` reads accurate per iter-171 LOC delta. But should the row's `Iters left ~3-5` decrement to ~2-3 now that body-skeleton landed and the 3 internal sorries are isolated mechanical/deep targets?

## Format

Per descriptor (`.archon/subagents/strategy-critic.md`), reply with verdict per row + flagged challenges (if any) + estimation refinements.
