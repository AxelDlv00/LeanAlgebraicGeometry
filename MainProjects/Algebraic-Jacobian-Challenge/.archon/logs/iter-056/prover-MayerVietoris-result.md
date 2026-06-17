# AlgebraicJacobian/Cohomology/MayerVietoris.lean

## Iter-056 result: RESOLVED

Appended two pairwise basic-open intersection helpers inside `namespace AlgebraicGeometry.Scheme`'s `section CoverTotality`, immediately after iter-055's `hasAffineCechAcyclicCover_of_basicOpen_curve` and before the closing `end CoverTotality`. Used the verbatim probe-confirmed bodies from PROGRESS.md.

### Declarations added

1. **`basicOpenCover_inter_eq_basicOpen_mul`** (now at L1427-1450)
   - Pairwise intersection identification: `basicOpenCover s i ⊓ basicOpenCover s j = C.left.basicOpen (i.1 * j.1)`.
   - Body: `by unfold basicOpenCover; exact (Scheme.basicOpen_mul C.left _ _).symm`.

2. **`basicOpenCover_inter_isAffineOpen`** (now at L1466-1474)
   - Pairwise intersection on an affine open is itself affine.
   - Body: `by unfold basicOpenCover; rw [← Scheme.basicOpen_mul]; exact hU.basicOpen _`.

### Verification (this session)

- `lean_diagnostic_messages` on `MayerVietoris.lean` → `{success: true, items: [], failed_dependencies: []}`. Zero errors, zero warnings.
- `lean_verify AlgebraicGeometry.Scheme.basicOpenCover_inter_eq_basicOpen_mul` → axioms `[propext, Classical.choice, Quot.sound]` (kernel-only). The "local instance" warning at L259 is pre-existing, unrelated to iter-056.
- `lean_verify AlgebraicGeometry.Scheme.basicOpenCover_inter_isAffineOpen` → axioms `[propext, Classical.choice, Quot.sound]` (kernel-only).
- Sorry count: `9 total across 3 file(s)` — unchanged (`Jacobian.lean: 5`, `AbelJacobi.lean: 3`, `Picard/Functor.lean: 1`). No new sorry introduced.
- File LOC: `1429 → 1477` (+48; within the +30-50 plan band).

### Notes for the review agent

Both declarations are ready for the `\leanok` marker on their statement blocks in `blueprint/src/chapters/Cohomology_MayerVietoris.tex` § *Pairwise basic-open intersection helpers (iter-056)* — proofs are fully closed (no `sorry`), so the proof blocks also qualify for `\leanok`.

### Notes for the next prover/plan agent

- No deviation from PROGRESS.md plan; no informal-agent escalation needed.
- Iter-057+ may now consume both helpers when evaluating the Čech complex on basic-open covers (binary intersection at degree 1 of the Čech cochain).
- N-ary generalisation to `Fin (n+1)` / `Finset` indexing remains deferred to iter-057+ as planned.
