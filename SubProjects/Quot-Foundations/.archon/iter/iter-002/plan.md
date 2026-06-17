# Iter 002 — Plan (Quot-Foundations)

## TL;DR

First prover-dispatch iter. Both mandatory critics ran. The HARD GATE was cleared this iter via a
same-iter fast path: blueprint-reviewer flagged the FBC chapter `correct: partial` (one
underived naturality step), a blueprint-writer fixed it, and a scoped re-review returned it
`complete + correct`. The strategy-critic CHALLENGE on QUOT was addressed by a STRATEGY.md
rewrite (encoding decision + Grassmannian decomposition + format fix). **Two frontier prover lanes
dispatched: GF (FlatteningStratification.lean) and FBC-A (FlatBaseChange.lean).** QUOT prover work
stays deferred pending a predicate-design track (queued). Build GREEN throughout.

## State at entry

- iter-001 was strategy+blueprint repair; NO prover work, so the `.lean` files are unchanged from
  the initial commit. 7 sorry nodes. 3 frontier nodes all pin to `AlgebraicGeometry.TODO.*`
  placeholders (scaffold targets, not fill-the-sorry).
- The GF algebraic finite-module core is already proved axiom-clean (`GenericFreeness.*` —
  `exists_free_localizationAway_of_{finite,moduleFinite}`). The deep residue is the finite-type-B
  dévissage.

## Critics

**blueprint-reviewer (iter002):** 3/4 chapters clear the gate. `Cohomology_FlatBaseChange.tex`
`correct: partial` — sole must-fix: the proof of `lem:base_change_map_affine_local` asserted its
key naturality step ("pushforwardBaseChangeMap built from units/counits … Granting this
compatibility") instead of deriving it. Both `\mathlibok` anchors verified faithful
(`LinearMap.tensorEqLocusEquiv`, `Functor.IsRepresentable`). All 6 strategy phases have coverage —
no unstarted-phase proposals.

**strategy-critic (iter002):** FBC SOUND, GF SOUND (pivot is genuine; all named Mathlib prereqs
verified). QUOT **CHALLENGE** — (1) `def:hilbert_polynomial` encoding undecided; Mathlib graded
`Polynomial.hilbertPoly` may dissolve the Snapper gap; (2) Grassmannian-as-scheme is an
undecomposed 400–1000 LOC monolith. Format **DRIFTED** — per-iter parentheticals; `## Routes`
covered only FBC.

## Actions taken

1. **FBC gate fix (fast path).** Dispatched blueprint-writer `fbc-affinelocal` → replaced the
   asserted compatibility with an explicit 3-step derivation (unfold transpose-of-unit → push
   restriction through each block via transpose naturality + pushforward-commutes-with-restriction
   → apply locality criterion). Scoped re-review `fbc-rereview` returned the chapter
   `complete: true` + `correct: true`, no must-fix. Gate satisfied for FBC this iter.
2. **Repins (1-to-1, tex alongside Lean).** The three scaffold targets the provers create this iter
   were repointed from `TODO.*` to their real names: `genericFlatnessAlgebraic`,
   `base_change_map_affine_local`, `pushforward_base_change_mate_cancelBaseChange`.
3. **STRATEGY.md rewrite** (107 lines / 8.8 KB; blueprint-doctor clean) — see Decisions.
4. **Two prover lanes** written to PROGRESS (GF, FBC-A), both default `prove`.

## Decisions made

### QUOT hilbert-polynomial encoding = cohomological χ (addresses strategy-critic CHALLENGE)
- **Why:** The parent's `def:hilbert_polynomial` IS the fiberwise Euler characteristic
  `Φ_s(m)=χ(X_s, F|_{X_s}⊗L_s^m)` (Nitsure §1 SOURCE QUOTE in the chapter; confirmed by the Lean
  stub `hilbertPolynomial : … → Polynomial ℚ`). It is the invariant locally constant in flat
  families and is what `def:quot_functor` stratifies by. Mathlib's graded
  `Polynomial.hilbertPoly`/`existsUnique_hilbertPoly` (VERIFIED present) compute the graded-module
  Hilbert–Serre polynomial — a different invariant, NOT the flat-family χ — so they do not
  substitute, but they ARE a building block for the fiberwise polynomiality once χ exists.
- **Evidence:** `grep eulerCharacteristic Mathlib/AlgebraicGeometry/` = 0 hits — coherent-sheaf
  cohomological χ is genuinely absent.
- **Consequence:** carved out a dedicated **SNAP** phase (S1 coherent cohomology finiteness + χ
  additive; S2 Snapper polynomiality via graded `hilbertPoly`), replacing the buried one-line risk
  note. BLOCKED; gates `def:hilbert_polynomial`.
- **Cheapest reversal signal:** if a downstream consumer turns out to need only a graded Hilbert
  polynomial (not the flat-family χ), switch to the Mathlib graded route and SNAP largely dissolves.

### Grassmannian-as-scheme decomposed (addresses infrastructure-deferral CHALLENGE)
QUOT-repr split in `## Routes` into GR-cells (affine big cells), GR-glue (Plücker cocycle gluing +
separatedness), GR-quot (tautological quotient + universal property), GR-repr (functor-of-points →
RepresentableBy), each with an LOC estimate. GR-repr still gated on the RelativeSpec strengthening
(Open question, deferred — QUOT-repr is many iters out).

### Format drift fixed
Stripped `(pivoted iter-001)` / `(surfaced iter-001)` parentheticals; added GF and QUOT route
prose so `## Routes` covers all three targets.

### QUOT prover work deferred this iter (not a stall)
The QUOT predicate sub-builds (schematic-support/proper-support; rank-`r` local-freeness) have real
design questions (encoding shape) and have no blueprint decl blocks with `\lean{}` yet. Sending a
prover now would formalize an unspecified shape. Correct order = mathlib-analogist (shape) →
blueprint-writer (decl blocks) → mathlib-build → re-sign. Queued for iter-003. The frontier work
(FBC-A, GF) is the higher-leverage load this iter; the two lanes are deep enough to fill the iter.

## Prior critique status

- iter002 strategy-critic QUOT CHALLENGE (encoding) — **addressed** (STRATEGY ## Routes QUOT
  decision; SNAP phase added).
- iter002 strategy-critic QUOT infrastructure-deferral (Grassmannian monolith) — **addressed**
  (GR-cells/glue/quot/repr decomposition in ## Routes).
- iter002 strategy-critic format DRIFTED — **addressed** (parentheticals stripped; GF/QUOT route
  prose added). Did NOT re-dispatch strategy-critic (address-or-rebut satisfied by the rewrite;
  decisions grounded in verified Mathlib facts + the chapter source quote).
- iter002 blueprint-reviewer FBC `correct: partial` — **addressed** (writer fix + scoped re-review
  cleared it).

## Subagent skips

- progress-critic: prior iter (001) ran NO prover phase — there is no trajectory data to assess
  (the dispatcher-notes skip condition "the prior iter ran no prover phase" is met). First real
  prover dispatch happens THIS iter; progress-critic becomes meaningful from iter-003.

## Risks / watch-items

- GF `genericFlatnessAlgebraic` full dévissage is deep (effort ~3894); this iter targets scaffold +
  re-sign + GF-geo wrapper, with partial dévissage progress. If it stalls, effort-break next iter.
- FBC-A obligation (2) — whether `Γ(pushforwardBaseChangeMap)` identifies with `cancelBaseChange`
  without a residual mate computation — gets empirically tested by lane 2 this iter (STRATEGY Open
  question). The blueprint's 4-step generator trace says it is direct; the prover validates.
