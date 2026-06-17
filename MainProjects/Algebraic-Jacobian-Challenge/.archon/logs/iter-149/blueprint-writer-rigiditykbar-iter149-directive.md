# Blueprint Writer Directive

## Slug
rigiditykbar-iter149

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Strategy context

The chart-algebra piece (ii) envelope in `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
is the live critical path. Three of five sub-pieces are closed sorry-free
(α pushout, β-core df-zero-factors-via-KDM, scheme-level lift). Two remain
partial: KDM ring-side and constants substep 3. The iter-148 prover lane
reduced the constants substep 3 proof body to a single consolidated
`IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ` `sorry`, factored
mathematically into four named sub-claims `(S3.pi.1)`, `(S3.pi.2)`,
`(S3.sep.1)`, `(S3.sep.2)`. The KDM (p2) char-0 bridge is structured
into five sub-steps `(BR.1)`–`(BR.5)`.

The iter-149 mandatory blueprint-reviewer flagged `RigidityKbar.tex` as
`complete: partial` and fired the HARD GATE, identifying as the single
must-fix-this-iter the fact that the four `(S3.*)` sub-claims live as
`%`-prefixed comment text inside the proof body of
`lem:constants_integral_over_base_field`, NOT as first-class blueprint
declarations with their own `\label{}` and `\lean{}` hints. The iter-149
mandatory progress-critic returned **CHURNING** on Route 1 with
**Blueprint expansion** as the named primary corrective for exactly the
same reason: an iter-149+ prover lane (~370–610 LOC across the (S3.*)
sub-claims + (BR.*) bridge) needs each sub-claim to attach to a
canonical blueprint label.

The iter-149 strategy-critic produced complementary CHALLENGES:
- Path (b) "smart-proof bypass step (e)" framing slightly understates
  the work — the (S3.pi.1) flat-base-change content IS the same content
  as path (a) step (e), just re-packaged (per
  `references/literature-crosscheck-iter149.md`).
- The `Differential.ContainConstants` typeclass lives in the
  differential-algebra (Picard–Vessiot) framework, parameterised by
  `[Differential B]` — an abstract derivation `B → B`, not the universal
  Kähler derivation `B → Ω[B⁄A]`. The (BR.3)–(BR.5) bridge from
  `KaehlerDifferential.D` to `Differential B` is project-internal infra
  not Mathlib infra.

Your job is to promote the (S3.*) sub-claims and (BR.*) sub-steps to
first-class blueprint declarations + add Stacks Tag citations + revise
the path (b) framing to acknowledge it does not bypass flat base change.

## Required content

### 1. Promote the four (S3.*) sub-claims to first-class lemma blocks

The current location is L2030–2066 of `RigidityKbar.tex`, inside the
proof body of `lem:constants_integral_over_base_field`. The four named
sub-claims must each become a first-class `\begin{lemma}` block. Place
the new blocks BEFORE the proof of `lem:constants_integral_over_base_field`
(so the proof can `\uses{}` them). Keep the comment NOTE pointer
authority-of-record but trim it to a one-sentence cross-reference.

For each sub-claim:

**`lem:S3_sep_1_smooth_geometrically_reduced_Gamma`** — Smooth ⇒ Γ is
geometrically reduced over the base.
- `\label{lem:S3_sep_1_smooth_geometrically_reduced_Gamma}`
- `\lean{AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth}` (target
  Lean declaration name; provers may adjust the namespace)
- `\uses{}`: empty (this is the gateway sub-claim)
- Statement: Let `X` be a smooth proper scheme over a field `k`. Then
  `Γ(X, O_X)` is a geometrically reduced `k`-algebra (Mathlib's
  `Algebra.IsGeometricallyReduced k Γ(X, O_X)`).
- Proof sketch: Smoothness of `X / Spec k` implies that for any field
  extension `K / k`, `X_K` is reduced (smooth ⇒ formally smooth ⇒
  geometrically reduced fibers, Stacks Tag **0334** + **04QM**). Then
  `Γ(X_K, O_{X_K})` injects into the local rings of `X_K`, which are
  reduced; hence `Γ(X_K, O_{X_K})` is reduced. By a flat-base-change
  identification (the same content as (S3.pi.1) below), this gives that
  `Γ(X, O_X) ⊗_k K` is reduced for every field extension `K/k`, i.e.
  geometrically reduced.
- Estimated build: ~80–150 LOC.

**`lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable`** —
geometrically reduced finite field extension is separable.
- `\label{lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable}`
- `\lean{Algebra.IsSeparable.of_isGeometricallyReduced_of_finite}` (target name)
- `\uses{lem:S3_sep_1_smooth_geometrically_reduced_Gamma}` — uses the
  preceding sub-claim to instantiate the geom-reducedness hypothesis
- Statement: Let `F / k` be a finite field extension of fields. If `F`
  is geometrically reduced as a `k`-algebra (in the sense of `Algebra.
  IsGeometricallyReduced k F`), then `F / k` is a separable extension
  (`Algebra.IsSeparable k F`).
- Proof sketch: Recall `Algebra.IsGeometricallyReduced k F` means
  `F ⊗_k \bar k` is reduced. For a finite field extension `F/k`,
  `F ⊗_k \bar k ≅ ∏_i F_i` with each `F_i` a quotient of `F ⊗_k \bar k`;
  reducedness forces each `F_i` to be a field. The dimension count
  `dim_{\bar k} (F ⊗_k \bar k) = [F : k]` plus the count of distinct
  embeddings `F ↪ \bar k` forces `F / k` to be separable. (Citations:
  Stacks Tag **0BJF** "field extension is separable iff base change to
  algebraic closure is reduced"; Bourbaki *Algèbre* Chap. V §15 N° 3.)
- Estimated build: ~30–50 LOC.

**`lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper`** — flat base
change of Γ for proper schemes.
- `\label{lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper}`
- `\lean{AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper}` (target name)
- `\uses{}`: empty
- Statement: Let `X` be a proper scheme over a field `k`, and `K / k` a
  field extension. Then the canonical map
  `Γ(X, O_X) ⊗_k K → Γ(X_K, O_{X_K})` is an isomorphism of `K`-algebras.
  (This is the specialisation of "cohomology along proper morphisms
  commutes with flat base change" — Stacks Tag **02KH** — to `H^0`.)
- Proof sketch: Cover `X` by finitely many affine opens `U_i = Spec A_i`
  (quasi-compactness from properness). The Čech complex computes
  `Γ(X, O_X)` as the equalizer of `∏_i A_i ⇒ ∏_{i,j} A_{ij}`. Tensoring
  with `K` over `k` preserves the equalizer (flatness of `K / k`). Then
  apply that `(A ⊗_k K) ≅ Γ(U_K, O_{U_K})` for affine `U` (Stacks Tag
  **00DS** flat base change for affines) chart-by-chart and reassemble.
  Citations: Stacks Tag **02KH** (cohomology + flat base change), Stacks
  Tag **0AY8** (descent of integral closure), Hartshorne III.9.3.
- Estimated build: ~150–250 LOC (the dominant cost is the Čech equaliser
  + flat-tensor exchange chase).
- **Honesty note**: this is the SAME content as path (a) step (e) of
  the iter-147 7-step chain, not bypassed by path (b). Path (b)'s
  genuine advantage is that it packages the flat-base-change content as
  ONE Mathlib lemma request rather than as a 7-step ad-hoc chain
  scattered across `Γ_{\bar k}`-cohomology infrastructure.

**`lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange`** —
finite-dim k-algebra with reduced base-change to `\bar k` having a
unique minimal prime is purely inseparable.
- `\label{lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange}`
- `\lean{Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange}` (target name)
- `\uses{lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper}`
- Statement: Let `F / k` be a finite extension of fields with `F` a
  finite-dimensional `k`-algebra such that `F ⊗_k \bar k` has a unique
  minimal prime (equivalently, `Spec (F ⊗_k \bar k)` is irreducible).
  Then `F / k` is purely inseparable (`Algebra.IsPurelyInseparable k F`).
- Proof sketch: `F ⊗_k \bar k` is a finite-dimensional `\bar k`-algebra.
  Its reduction `(F ⊗_k \bar k) / \mathrm{Nil}`, with unique minimal
  prime, is a domain finite over `\bar k`, hence a field finite over
  `\bar k` (Artinian + integral domain). Since `\bar k` is algebraically
  closed, the field is `\bar k` itself. Hence `(F ⊗_k \bar k) / \mathrm{Nil}
  ≅ \bar k`. The `k`-algebra `F` therefore has all its geometric points
  collapse to a single point — the definition of pure inseparability via
  Stacks Tag **05DH** ("purely inseparable iff `_ ⊗_k \bar k` is local"
  for finite extensions). Citations: Stacks Tag **05DH**, **030V**;
  Bourbaki *Algèbre* Chap. V §7 N° 7.
- Estimated build: ~50–100 LOC.

### 2. Adopt (BR.1)–(BR.5) labels for the KDM (p2) bridge

The current location is L2133 of `RigidityKbar.tex` (inside the proof
body of `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`,
in the "Primary path (p2)" paragraph). The text already names the
five conceptual sub-steps (standard-smooth chart presentation +
free-rank-n basis + coefficient-derivation projection + `Differential B`
instance per coefficient + `ContainConstants` discharge). Restructure
the prose as an enumerated `\begin{itemize}` list with explicit
`\textbf{(BR.1)}` … `\textbf{(BR.5)}` labels and per-item estimates,
mirroring the (p1.a)–(p1.f) structuring already in place for the
alternative char-`p` path. The text content stays the same; only the
labelling + structuring changes.

The five sub-steps the writer should label and structure (paraphrased
from the existing prose):

- **(BR.1)** Inflate the KDM signature with `[CharZero k]` +
  `[Algebra.IsStandardSmoothOfRelativeDimension k B]`. (Signature
  refactor; no new lemma.)
- **(BR.2)** Basis selection of `Ω_{B/k}` via
  `Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified in
  Mathlib snapshot b80f227, `Mathlib.RingTheory.Smooth.
  StandardSmoothCotangent`]. (Existing Mathlib lemma; no project work.)
- **(BR.3)** Coefficient-derivation extraction `∂_i : B → B` from the
  basis. No off-the-shelf Mathlib lemma. ~30–50 LOC of project work.
  Suggested target name `KaehlerDifferential.coordinateDeriv`.
- **(BR.4)** `Differential B` instance per `∂_i` (the `∂_i` is a
  `Derivation ℤ B B` because it is k-linear hence ℤ-linear). ~10–20
  LOC; assemblable from `RingTheory.Derivation.Basic`. Suggested name
  `KaehlerDifferential.coordinateDerivDifferentialInstance`.
- **(BR.5)** `Differential.ContainConstants` instance for the chosen
  `∂_i` in `CharZero k` + `Algebra.IsStandardSmooth k B`. ~40–80 LOC;
  Mathlib has the class definition but no instance for the standard-
  smooth + CharZero case. Suggested name
  `KaehlerDifferential.coordinateDeriv_containConstants_of_charZero`.

Add a one-paragraph wrap-up after (BR.5) explaining how (BR.1)–(BR.5)
compose to close the (p2) forward direction body. Aggregate
estimate: ~80–150 LOC for the full bridge body.

Do **not** promote (BR.3)–(BR.5) to first-class lemma blocks in the
chapter — they live as sub-steps inside the (p2) bridge proof, which is
itself the proof body of `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`.
A prover that wants per-sub-step Lean lemmas can extract them locally.
The labelling is sufficient for cross-referenceability.

### 3. Add Stacks Tag + literature citations

The `references/literature-crosscheck-iter149.md` file is authoritative.
Adopt its citations as `\emph{Citations.}` blocks at the end of the
proof blocks (NOT in `\uses{}` — `\uses{}` is for cross-references to
other blueprint labels, not external sources).

- `lem:constants_integral_over_base_field` proof block: add a final
  `\emph{Literature.}` block citing Stacks Tag **0BUG** ("Γ of proper
  geometrically integral is finite separable field extension"),
  Stacks Tag **02KH** ("flat base change of cohomology for proper
  morphisms"), and Hartshorne III.5.2.

- `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` proof
  block: add a final `\emph{Literature.}` block citing Stacks Tag
  **07F4** ("char-`p` Cartier direction `ker D ⊇ B^p`"), Eisenbud
  *Commutative Algebra with a View Toward Algebraic Geometry* §16
  ("Kähler differentials and derivation kernels"), and Mathlib's
  `Differential.ContainConstants` class as the (p2) char-0 closer.

- `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper` proof block: add
  a final `\emph{Literature.}` block citing Stacks Tag **02KH** and
  Stacks Tag **0AY8** ("integral closure descends under flat base
  change").

### 4. Revise path (b) framing

Replace the iter-148 NOTE block at L2030–2066 (inside the proof body
of `lem:constants_integral_over_base_field`). The new text should:

- Acknowledge that path (b) does NOT bypass the flat-base-change-of-Γ
  content — the (S3.pi.1) sub-claim's mathematical content is the same
  content as path (a) step (e), just packaged as a single Mathlib lemma
  request rather than a 7-step ad-hoc chain. Cite the
  `references/literature-crosscheck-iter149.md` finding directly.
- Replace any reference to "path (b) bypasses step (e)" with "path (b)
  re-packages the flat-base-change content of step (e) into a single
  named Mathlib request".
- Keep the four (S3.*) sub-claim references but trim to a one-sentence
  cross-reference (now that they are first-class blueprint citizens).
- Drop the "iter-148 review" prefix in the NOTE block in favour of an
  iteration-agnostic framing.

## Out of scope

- DO NOT edit any other chapter.
- DO NOT touch `\leanok` or `\mathlibok` markers. The `sync_leanok` phase
  and review agent own those.
- DO NOT add a Lean target for `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`
  (the unleaned helper at L2092). That is a separate iter-149+ scheduling decision.
- DO NOT remove the existing 7-step (a)–(g) chain on
  `lem:constants_integral_over_base_field` proof body. That chain stays
  as an informational alternative (path (a) BUILD-IT). Update it only
  to acknowledge that step (e) is the SAME content as (S3.pi.1) above.
- DO NOT touch the (p1.a)–(p1.f) char-`p` sub-step structure of the KDM
  block. That stays as-is.
- DO NOT modify `\thm:rigidity_over_kbar`, `\thm:GrpObj_eq_of_eqOnOpen`,
  or any block outside the chart-algebra piece (ii) decomposition
  section.

## References

- `references/literature-crosscheck-iter149.md` — authoritative for the
  citations and the "path (b) does not bypass" framing.
- `blueprint/src/chapters/RigidityKbar.tex` itself — read the existing
  chart-algebra piece (ii) section (L1828–2216) for the local context.

## Expected outcome

After your round, the chart-algebra piece (ii) decomposition section in
`RigidityKbar.tex` carries:
- Four NEW first-class `\begin{lemma}` blocks for (S3.sep.1), (S3.sep.2),
  (S3.pi.1), (S3.pi.2), each with `\label{}`, `\lean{}` hint, `\uses{}`
  field, statement, and proof sketch.
- The (p2) bridge of `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
  is restructured as a `\begin{itemize}` list with explicit (BR.1)–(BR.5)
  labels and per-step LOC estimates.
- Stacks Tag citations added as `\emph{Literature.}` blocks at the end
  of the relevant proof blocks.
- Path (b) framing acknowledges the flat-base-change content is not
  bypassed; the iter-148 NOTE block is replaced with an iteration-
  agnostic version.

The iter-149 prover lane on `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
can then target each first-class (S3.*) sub-claim by name (one Lean
declaration per blueprint lemma), with `\uses{lem:S3_*}` cross-references
working correctly in the depgraph.
