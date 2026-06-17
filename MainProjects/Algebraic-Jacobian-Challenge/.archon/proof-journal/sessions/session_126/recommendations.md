# Recommendations for the next plan-agent iteration (iter-127)

## Top priority — iter-127 commitments already binding

These are not free-form recommendations; they are the iter-128
TRIPWIRE and the iter-126 plan-agent's pre-commitments. The
iter-127 planner must execute them.

### CRITICAL #1 — Stage ≥1 concrete cotangent-pile sub-lemma for iter-128 prover dispatch

Per the iter-126 `progress-critic-iter126` META-PATTERN TRIPWIRE:
**iter-128 MUST dispatch a prover on a concrete cotangent-pile
sub-lemma OR the meta-pattern flips to CHURNING with mandatory
corrective**. iter-127 plan-agent commits to staging this target.

Concrete recipe (from the iter-126 mathlib-analogist's piece-(i)
decomposition; see `analogies/cotangent-vanishing-pile.md`):

1. Read `analogies/cotangent-vanishing-pile.md` § "Piece (i)
   decomposition" for the Lie-algebra-of-GrpObj +
   mulRight-globalisation + relative-cotangent-presheaf-trivialisation
   sub-step chain.
2. Extract the **first prover-actionable sub-lemma**. Candidate names
   the analogist surfaced: a `GrpObj`-side Lie-algebra constructor,
   the `mulRight`-translation invariance of a left-invariant
   differential form, or a presheaf-section trivialisation on a
   basic-open cover. Pick the sub-lemma whose Mathlib leverage is
   most concrete and whose proof has clearly-bounded length
   (~30-100 LOC).
3. Either:
   a. Stage as a refactor target (new declaration with `sorry` body)
      via `refactor-rigiditykbar-piece-i-scaffold-iter127`, OR
   b. Author a 1-paragraph blueprint stub in `RigidityKbar.tex`
      § Shared pile piece (i) decomposing the sub-lemma.
4. Iter-128 prover dispatches against the staged target.

**Fallback if staging fails**: dispatch
`blueprint-writer-rigiditykbar-piece-i-iter127` instead this iter,
deferring the prover lane to iter-129. This is acceptable per the
TRIPWIRE wording ("if no prover-ready sub-lemma can be extracted,
the corrective is blueprint expansion").

### CRITICAL #2 — Dispatch M2.b scaffold refactor (`refactor-m2b-scaffold-iter127`)

Per STRATEGY.md § Sequencing + PROGRESS.md § Watch criteria:
iter-127 dispatches the M2.b scaffold. New declaration:

- `genusZeroWitness {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] (h : genus C = 0) :
  JacobianWitness C`

The `isAlbaneseFor` field branches on `C(k) = ∅` (vacuous) vs
`C(k) ≠ ∅` (apply `rigidity_over_kbar` after base-change to `kbar`
+ Galois descent of morphism equality; OR via the direct-over-k
alternative if that variant becomes viable per CRITICAL #3 below).

Expected net sorry change: +0 or +1 (the vacuity branch may close
in-body; the rigidity-application branch keeps a residual sorry
until M2.a body lands iter-138+).

### CRITICAL #3 — Dispatch the over-k mathlib-analogist follow-up consult

Per the iter-126 strategy-critic alternative #1: dispatch
`mathlib-analogist-cotangent-vanishing-pile-over-k-iter127` to scope
the over-k variant (vs the over-`k̄` variant the iter-126 analogist
already scoped). The over-k variant may eliminate M2.c (Galois
descent of morphism equality), saving 4-8 iter / 300-500 LOC.

Result feeds the M2.b scaffold's branch design (CRITICAL #2) — if
the over-k variant is viable, the M2.b vacuity-branch closure
doesn't need to set up the descent infrastructure.

## Major

### MAJOR #1 — `RigidityKbar.lean` docstring/signature framing mismatch (lean-auditor flag)

`lean-auditor-iter126` major finding: the file header (L9-16) and
the `rigidity_over_kbar` docstring (L58-69) say "algebraically closed
field `k̄`", but the signature requires only `[Field kbar]`, not
`[IsAlgClosed kbar]`. The `[GeometricallyIrreducible …]` typeclass
hypotheses encode the post-base-change content, so the statement is
mathematically defensible (and strictly stronger as written — it
applies over any field), but the framing-vs-hypothesis mismatch is
confusing.

**Recommended action for iter-127 plan-agent**: dispatch a small
`refactor-rigiditykbar-framing-iter127` to either (a) add
`[IsAlgClosed kbar]` to the signature (tightens to Mumford's literal
formulation; may be needed anyway when piece (iii) Frobenius
iteration descent lands), or (b) soften the docstring to say
"intrinsic to `kbar` via `GeometricallyIrreducible` typeclasses
encoding the post-base-change content; no `[IsAlgClosed]` required
for the *statement* but may be added at iter-129+ if the body
closure forces it".

The `lean-vs-blueprint-checker-rigiditykbar-iter126` minor #2
identifies this same concern from the chapter side and recommends a
one-line note in the Encoding-note paragraph at L29. Either way,
iter-127 fix is low-LOC.

### MAJOR #2 — Iter-loop narrative cruft (lean-auditor flag carry-overs)

Two major lean-auditor findings are iter-loop narrative cruft in
files outside this iter's prover lane:
- `Rigidity.lean:70-78` "Unused-hypothesis cleanup (iter-125)" sub-
  block — pure changelog narrative. Defensible to keep for
  traceability but candidate for relocation to a release-notes file.
- `Cohomology/StructureSheafModuleK.lean:462-486` — 25-line "Historical
  note on the abandoned per-affine-open variant" in the docstring of
  `IsHModuleHomFinite`. Mathematically correct content but heavy
  volume for a single-field class. Trim candidate.

**Recommended action**: optional `refactor-cleanup-iter127` (low
priority; can be deferred to iter-128+ or rolled into the
`framing-iter127` refactor above).

## Minor (carry to plan-phase, not iter-127 blocking)

- `Genus.lean` and `Cohomology/SheafCompose.lean` still use the
  whole-Mathlib `import Mathlib` umbrella (lean-auditor minor #1+#2).
  Build-time cost only; not a correctness issue.
- `Cohomology/MayerVietorisCore.lean` has 4 `set_option
  backward.isDefEq.respectTransparency false in` (lean-auditor minor
  #3). Justified at each use site; could consolidate.
- `MayerVietorisCover.lean` has heavy `_curve` boilerplate
  (lean-auditor minor #5) and forward-iter narrative drift
  (minor #4).
- `lean-vs-blueprint-checker-rigiditykbar-iter126` minor #1: C.2.e
  sub-step in `RigidityKbar.tex` L55 is a thin one-liner waving at
  "integrated into C.2.b". A future blueprint-writer pass could
  expand it to one extra sentence spelling out the
  `Scheme.Over.ext_of_eqOnOpen` application detail.
- `lean-vs-blueprint-checker-differentials-iter126` minor: the
  `Differentials.tex` "Mathlib name summary" at
  `thm:smooth_locally_free_omega` cites
  `AlgebraicGeometry.Scheme.component_nontrivial` for Step 4.5,
  but the Lean code discharges `Nontrivial B` via the simpler
  `Nonempty V := ⟨⟨x, hxV⟩⟩` + `algebraize` chain. Low-impact
  prose-vs-Lean drift only.

## Blocked / DO NOT retry

- **M1.b body closure on `appLE_isLocalization`** — this declaration
  is EXCISED this iter and gone from the tree. Do not propose
  re-instating it; the M1.d Mathlib-PR candidate
  `kaehler_quotient_localization_iso` is the only retained M1
  artifact and stays standalone.
- **Adding any new axiom to the project** — per the iter-126 user
  hint reaffirmation, "no good reason for an axiom or not do the
  work". Plan-agents may NOT propose named-axiom escape valves.
  This applies to both M2 closures and M3 routes; the strategy
  document has been cleansed of axiom alternatives.

## Reusable proof patterns (for future provers)

No new patterns this iter (plan-phase-only iter with no prover lane;
no new closure techniques to crystallize). Existing iter-122 +
iter-123 + iter-124 patterns in PROJECT_STATUS.md § Knowledge Base
remain available.

The iter-126 mathlib-analogist's persistent file
`analogies/cotangent-vanishing-pile.md` is the iter-129+ build
reference; iter-127 plan-agent consumes it directly for staging
sub-lemma targets.

## Stage advance

Stage stays at `prover`. No advance.

The iter-126 progress-critic's META-PATTERN TRIPWIRE means iter-128
MUST produce prover-stage work, not another plan-phase-only iter.
iter-127 plan-agent's CRITICAL #1 commitment exists specifically to
prevent the TRIPWIRE from firing.
