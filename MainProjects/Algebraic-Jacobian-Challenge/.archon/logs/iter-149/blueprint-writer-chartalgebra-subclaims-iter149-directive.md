# Blueprint Writer Directive

## Slug
chartalgebra-subclaims-iter149

## Iteration
149

## Chapter under edit

`blueprint/src/chapters/RigidityKbar.tex`

## Authorisation context (read carefully)

The iter-149 progress-critic (CHURNING verdict on Route 1) named
**Blueprint expansion** as the primary corrective before any further
prover lane: the iter-148 narrowing of substep 3 to four named
sub-claims (S3.pi.1, S3.pi.2, S3.sep.1, S3.sep.2) and the KDM
char-0 path's (BR.1)–(BR.5) inventory are currently INLINE COMMENT
BLOCKS in the chapter — they are scaffolding labels, not concretized
mathematical bridges. Before the iter-149 prover lane fires, each
sub-claim must be lifted into a top-level `\begin{lemma}` block
with its own `\label{...}` and `\uses{...}` PLUS a concrete proof
sketch citing the specific Stacks tags / Hartshorne / Eisenbud /
Mumford references where the classical content of the bridge lives.

## Strategy slice

The chart-algebra piece (ii) decomposition in `RigidityKbar.tex` §
"Chart-algebra piece (ii) first-class decomposition" carries five
sub-pieces; three are closed sorry-free in Lean (α, β-core, lift),
two are PARTIAL with structured sorries:

1. `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
   (KDM ring-side core) — Lean L123, partial. The iter-148 in-source
   docstring lists the (BR.1)–(BR.5) char-0 bridge sub-gap inventory,
   currently as inline comments inside the proof block. The (p1)
   char-p alternative path with sub-steps p1.a–p1.f is currently a
   separate proof-block paragraph, NOT split into independently
   target-able lemmas.

2. `lem:constants_integral_over_base_field` (substep 3 strong form
   `Γ(X, O_X) ≅ k`) — Lean L220 (proof body residual at L367),
   partial. The iter-148 review NOTE on the proof block lists the
   four (S3.pi.1)/(S3.pi.2)/(S3.sep.1)/(S3.sep.2) sub-claims as
   inline comments; iter-148 prover lane delivered the smart-proof
   framework but residual concentrates at the consolidated
   conjunction `IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ`.

## What to write

### Part A — Lift the (S3.*) sub-claims into proper lemma blocks

Insert (immediately AFTER `lem:constants_integral_over_base_field`'s
proof block, BEFORE the `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
block) four new lemma blocks, one per sub-claim:

#### Lemma `lem:Gamma_baseChange_proper`

- Label `\label{lem:Gamma_baseChange_proper}`.
- **NO `\lean{...}` hint** (no project Lean declaration of this
  shape yet; it will be scaffolded iter-149 prover lane as a project
  internal helper).
- `\uses{}` should reference the proper-scheme-over-field context.
- Mathematical content: for `X` proper over a field `k` and any
  field extension `K/k`, the canonical map
  `Γ(X, O_X) ⊗_k K → Γ(X_K, O_{X_K})` is an isomorphism.
- **Stacks tag citations**: Stacks Tag **02KH** (Γ finite over `k`
  for proper). Stacks Tag **0AY8** (flat base change of pushforward
  for proper morphisms). Hartshorne **III.5.2 / III.9.3.4**.
- Proof sketch (~10–20 lines of prose): outline the standard
  affine-cover + Čech equaliser + tensor-with-flat-exact chase.
- LOC estimate for the Lean side: **~150–250 LOC** ad hoc (no
  Mathlib pre-existing infrastructure for this; the
  `AlgebraicGeometry.IsBaseChange`/`R^iπ_*`-namespace is absent in
  Mathlib b80f227 per iter-148 mathlib-analogist).
- Mark `\notready` (the lemma is project material, not yet
  scaffolded).

#### Lemma `lem:Gamma_geometrically_irreducible_purely_inseparable`

- Label `\label{lem:Gamma_geometrically_irreducible_purely_inseparable}`.
- **NO `\lean{...}` hint** initially.
- `\uses{lem:Gamma_baseChange_proper}`.
- Mathematical content: for `X` proper geometrically irreducible
  over a field `k`, `Γ(X, O_X)` is a finite local `k`-algebra
  whose residue field is purely inseparable over `k`.
  Consequently, after passing to the algebraic closure
  `Γ ⊗_k \bar k` has a unique minimal prime.
- **Stacks tag citations**: Stacks Tag **0BUG** (Γ is a finite
  field extension of `k` when X is proper geometrically integral
  — see proof). Stacks Tag **04KV** (geometrically irreducible
  ⇒ residue field at generic fibre purely inseparable). Hartshorne
  **III.5.2**.
- Proof sketch (~10–15 lines): combine geom-irr with the base-change
  identification of `lem:Gamma_baseChange_proper` to conclude `Γ ⊗
  \bar k` has unique minimal prime ⇒ `Γ` itself is purely inseparable
  as a `k`-algebra (after dimension reduction).
- LOC estimate: **~80–150 LOC** ad hoc.
- Mark `\notready`.

#### Lemma `lem:smooth_geometrically_reduced_Gamma`

- Label `\label{lem:smooth_geometrically_reduced_Gamma}`.
- **NO `\lean{...}` hint** initially.
- `\uses{}` (independent — uses only standing hypotheses on `X`).
- Mathematical content: for `X` smooth over a field `k`,
  `Γ(X, O_X)` is geometrically reduced as a `k`-algebra. (A smooth
  scheme over a field is geometrically reduced.)
- **Stacks tag citations**: Stacks Tag **056T** (smooth ⇒
  geometrically regular ⇒ geometrically reduced). Stacks Tag
  **038U** (geometrically reduced equivalents). Hartshorne **III.10.0.3**.
- Proof sketch (~8–12 lines): standard chain — smooth morphism
  has geometrically regular fibres; geometrically regular ⇒
  geometrically reduced; transport to `Γ` via the structure morphism.
- LOC estimate: **~60–120 LOC** ad hoc (the principal Mathlib bridge
  is `Algebra.IsGeometricallyReduced`; the missing instance is
  `Smooth ⇒ IsGeometricallyReduced` per iter-148 grep evidence).
- Mark `\notready`.

#### Lemma `lem:geometrically_reduced_finite_separable`

- Label `\label{lem:geometrically_reduced_finite_separable}`.
- **NO `\lean{...}` hint** initially.
- `\uses{lem:smooth_geometrically_reduced_Gamma}`.
- Mathematical content: a geometrically reduced finite-dimensional
  `k`-algebra that is a field is separable over `k`. (For proper
  smooth `X`, `Γ` is field-like by `lem:Gamma_baseChange_proper`
  + algebraic closure of `\bar k`; the residue field is therefore
  separable over `k`.)
- **Stacks tag citations**: Stacks Tag **030W** (separable ⇔
  geometrically reduced for finite field extensions). Hartshorne
  **III.10.0.3** + (Bourbaki Algèbre Chap. V §15 N° 6 for the
  separable ⇔ geometrically reduced equivalence).
- Proof sketch (~8–12 lines): finite + geometrically reduced
  + field ⇒ `K ⊗_k \bar k` is reduced + a finite-dim `\bar k`-
  algebra ⇒ a product of copies of `\bar k` ⇒ `K/k` separable.
- LOC estimate: **~40–80 LOC** ad hoc (essentially Mathlib's
  `IsSeparable.of_*` family after the bridge from
  `lem:smooth_geometrically_reduced_Gamma`).
- Mark `\notready`.

#### Update `lem:constants_integral_over_base_field`'s proof block

Replace the iter-148 review NOTE comment listing the four sub-claims
with explicit `\cref{...}` citations to the four new lemma blocks,
so the proof block reads:

> By `\cref{lem:smooth_geometrically_reduced_Gamma}` and
> `\cref{lem:geometrically_reduced_finite_separable}`, the
> `k`-algebra `Γ(X, O_X)` is separable. By
> `\cref{lem:Gamma_baseChange_proper}` and
> `\cref{lem:Gamma_geometrically_irreducible_purely_inseparable}`,
> `Γ(X, O_X)` is purely inseparable. Separable ∧ purely inseparable
> over `k` ⇒ trivial ⇒ `Γ(X, O_X) = k`. Closed via Mathlib's
> `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`.

Keep the 7-step (a)–(g) chain prose AFTER this new short proof
sketch as the "informational alternative path (a) BUILD-IT", clearly
labelled as such. The 7-step chain is no longer the primary proof
sketch; it's a fallback.

### Part B — Lift the (BR.*) sub-claims into proper lemma blocks (KDM)

Inside the `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
proof block, the iter-148 in-source docstring lists (BR.1)–(BR.5).
Lift each into a proper lemma block immediately AFTER this lemma
in the chapter:

#### Lemma `lem:kdm_coefficient_derivations_extraction`

- Label `\label{lem:kdm_coefficient_derivations_extraction}`.
- **NO `\lean{...}` hint** initially (project material).
- `\uses{}` referencing `Algebra.IsStandardSmooth.free_kaehlerDifferential`.
- Mathematical content: given a standard-smooth `k`-algebra `B`
  with relative dimension `n`, the universal Kähler derivation
  `D : B → Ω_{B/k}` can be decomposed coordinate-wise against the
  free basis `{db_1, …, db_n}` of `Ω_{B/k}` into `n` coefficient
  derivations `∂_i : B → B`, each a `k`-derivation. Each `∂_i` is
  the unique `k`-linear map satisfying `D = Σ_i (∂_i · db_i)`.
- **Eisenbud citation**: *Commutative Algebra with a View toward
  Algebraic Geometry* **§16.5** (the standard-smooth case of
  Kähler differentials and partial derivatives).
- **Stacks tag citation**: Stacks Tag **07F6** (the basis selection
  for `Ω_{B/k}` under standard-smoothness).
- Proof sketch (~10–15 lines): project `D` against the basis;
  verify Leibniz on each component; verify `k`-linearity.
- LOC estimate: **~30–50 LOC** ad hoc (Mathlib has the basis but
  not the coordinate extraction).
- Mark `\notready`.

#### Lemma `lem:kdm_differential_instance_per_coord`

- Label `\label{lem:kdm_differential_instance_per_coord}`.
- **NO `\lean{...}` hint** initially.
- `\uses{lem:kdm_coefficient_derivations_extraction}`.
- Mathematical content: each coefficient derivation `∂_i` from
  `lem:kdm_coefficient_derivations_extraction` extends to a
  `Differential B` typeclass instance in Mathlib's
  `Mathlib.RingTheory.Derivation.DifferentialRing` sense (a
  derivation `δ : R → R` viewed as a typeclass).
- **Mathlib citation**: `Mathlib.RingTheory.Derivation.DifferentialRing`
  L19 (`Differential` class); L62 (`ContainConstants` class).
- Proof sketch (~5–10 lines): the coefficient derivation IS a
  `Derivation k B B`; reading it as `Derivation ℤ B B` via the
  forgetful from `k`-linear to `ℤ`-linear gives the `Differential B`
  instance.
- LOC estimate: **~20–40 LOC** ad hoc (essentially a forgetful + typeclass
  wiring).
- Mark `\notready`.

#### Lemma `lem:kdm_containConstants_charZero_standardSmooth`

- Label `\label{lem:kdm_containConstants_charZero_standardSmooth}`.
- **NO `\lean{...}` hint** initially.
- `\uses{lem:kdm_differential_instance_per_coord}`.
- Mathematical content: for `B` a standard-smooth `k`-algebra over
  a field of characteristic 0 (i.e., `[CharZero k]`), each
  coefficient derivation `∂_i` from
  `lem:kdm_differential_instance_per_coord` contains the constants:
  if `∂_i b = 0` for all `i`, then `b ∈ (algebraMap k B).range`.
- **Eisenbud citation**: *Commutative Algebra* **§16.5–16.6** (the
  char-0 characterisation of constants via partial derivatives).
- **Mathlib bridge needed**: `Differential.ContainConstants` instance
  for `Algebra.IsStandardSmoothOfRelativeDimension` + `CharZero k`
  (verified absent iter-148; project must supply the bridge or PR
  to Mathlib).
- Proof sketch (~15–25 lines): char-0 + standard-smooth chart
  presentation `B = k[x_1, …, x_n] / I` (vanishing in `Ω` from
  the relations) ⇒ partial derivatives detect non-constants.
- LOC estimate: **~30–60 LOC** ad hoc.
- Mark `\notready`.

#### Update the KDM proof block

Replace the iter-148 (BR.1)–(BR.5) in-source docstring inventory
with explicit `\cref{...}` citations to the three new lemma blocks
above. Concretely the char-0 proof reads:

> Assume `[CharZero k]` and `[Algebra.IsStandardSmoothOfRelativeDimension k B]`.
> By `\cref{lem:kdm_coefficient_derivations_extraction}`, extract
> coefficient derivations `∂_1, …, ∂_n : B → B`. By
> `\cref{lem:kdm_differential_instance_per_coord}`, each `∂_i` is
> a `Differential B`. By
> `\cref{lem:kdm_containConstants_charZero_standardSmooth}`, the
> conjunction `∂_1 b = … = ∂_n b = 0` implies `b ∈ (algebraMap k B).range`.
> Since `D b = 0 ⇒ ∂_i b = 0` for every `i` by the basis decomposition,
> `D b = 0 ⇒ b ∈ (algebraMap k B).range`. ∎

This makes the prover lane's task discrete and incremental: each
sub-lemma is independently target-able.

### Part C — Update `\uses{...}` of consumer lemmas

The lemma blocks for `lem:constants_integral_over_base_field` and
`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` should
have their proof-block `\uses{...}` extended to cite the new
sub-claim lemmas (so the depgraph reflects the new structure).

## Out of scope

- **No new top-level chapter sections.** All new lemma blocks land
  within the existing § "Chart-algebra piece (ii) first-class
  decomposition" subsection.
- **Do NOT add `\leanok` or `\mathlibok` markers.** Those are
  managed deterministically by `sync_leanok` (the loop) and by the
  review agent respectively. The new lemmas should be plain
  `\begin{lemma}` blocks (no statement-block `\leanok`) since the
  Lean side has not yet scaffolded them; statement-block `\leanok`
  will be added by the deterministic sync after the iter-149 prover
  lane scaffolds the declarations.
- **Do NOT modify the chart-algebra (α) / (β-core) / (lift) lemma
  blocks.** Those are closed sorry-free; their content is final
  iter-146/iter-147.
- **Do NOT modify the `RigidityKbar.tex` chapter intro paragraphs
  or section headings.** Only the chart-algebra subsection content
  changes.
- **Do NOT modify other chapters (`Jacobian.tex`, etc.) in this
  dispatch.** Strategy-critic and blueprint-reviewer may dispatch
  separate writer rounds for those.

## References to consult

- `references/literature-crosscheck-iter149.md` — the plan agent's
  inline literature cross-check, containing Stacks tag citations
  for each sub-claim.
- `references/challenge.lean` — the protected signatures (read-only).
- Stacks Project online (https://stacks.math.columbia.edu/) — for
  Tag lookups: 0BUG, 02KH, 0AY8, 04KV, 056T, 038U, 030W, 07F4, 07F6.
- Hartshorne, *Algebraic Geometry*, Springer GTM 52 — Chapters
  II–III (specifically III.5, III.9, III.10).
- Eisenbud, *Commutative Algebra with a View toward Algebraic
  Geometry*, Springer GTM 150 — §16 (Kähler differentials).

If you find the Stacks Project / Hartshorne references genuinely
insufficient for any specific sub-claim, you are authorised to
spawn a `reference-retriever` child to fetch additional sources
under `references/` (see the `references/**` write-domain glob
authorised below). Do NOT fabricate citations; if a citation
cannot be located, report "citation not found for sub-claim X"
in your output rather than guessing.

## Verification expectations

After your edits, the `RigidityKbar.tex` chapter should:

- Contain 7 new lemma blocks (`lem:Gamma_baseChange_proper`,
  `lem:Gamma_geometrically_irreducible_purely_inseparable`,
  `lem:smooth_geometrically_reduced_Gamma`,
  `lem:geometrically_reduced_finite_separable`,
  `lem:kdm_coefficient_derivations_extraction`,
  `lem:kdm_differential_instance_per_coord`,
  `lem:kdm_containConstants_charZero_standardSmooth`).
- Have updated proof blocks for
  `lem:constants_integral_over_base_field` and
  `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
  citing the new sub-lemmas via `\cref{...}`.
- Each new lemma block has a concrete proof sketch (not just a
  citation) suitable for direct formalisation.
- Each new lemma block has at least one Stacks tag or classical
  textbook citation.

Verify your output by re-running plastex parse mentally (no need to
actually run `leanblueprint web` — the plan agent will do that
after your dispatch). The chapter LOC budget remains bounded; the
existing chapter is already long (~2233 LOC), so target
**~150–250 new LOC of prose** for the seven new lemma blocks and
the two consumer-proof updates.

## Out-of-band note

The chapter's existing 7-step (a)–(g) chain in
`lem:constants_integral_over_base_field`'s proof block should be
RETAINED as informational reference (path (a) BUILD-IT alternative)
but explicitly demoted: the primary proof sketch is now the
4-sub-claim citation chain above. Add a short paragraph at the top
of the 7-step chain marking it as the informational alternative,
e.g.: "The 7-step chain (a)–(g) below is the alternative path (a)
BUILD-IT, retained for reference; the primary closure is the
4-sub-claim chain above."
