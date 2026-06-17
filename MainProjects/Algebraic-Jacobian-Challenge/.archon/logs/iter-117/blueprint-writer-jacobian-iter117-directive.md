# Blueprint Writer Directive

## Slug

jacobian-iter117

## Target chapter

blueprint/src/chapters/Jacobian.tex

## Strategy context (iter-117 post-trim)

The project has been trimmed to a clean end-state with exactly one
inline `sorry`: the existence hypothesis `nonempty_jacobianWitness`
at `Jacobian.lean:179`. This existence claim is the single explicit
foundational hypothesis the project ships against. The blueprint
chapter needs to be the **detailed reference document** for what this
existence means, why it is true mathematically, and what Mathlib
infrastructure each classical proof route requires.

The chapter currently exists at `blueprint/src/chapters/Jacobian.tex`
with content describing the Albanese framework, the four protected
`Jacobian` instances, and the genus-0 sanity-check. The
`thm:nonempty_jacobianWitness` block exists but its proof body is
only a brief paragraph that bundles three construction routes
without decomposing them.

The user-stated requirement is: **blueprints should be detailed enough
to ensure that the provers have enough material**. For
`nonempty_jacobianWitness`, that means a careful decomposition of the
three classical constructions and the Mathlib infrastructure each
needs, written at textbook depth.

## Required content

### Keep with minor revisions

The following blocks are well-formed and stay as-is (with possible
minor polish):

- `\section{The Albanese construction}` overview.
- `def:IsAlbanese` (the universal property block).
- `thm:IsAlbanese_unique` (uniqueness of the Albanese object).
- `def:Jacobian` (the Lean definition as the underlying scheme of an
  Albanese witness).
- `\section{Group scheme structure and abelian-variety properties}`
  with the four protected instances (`thm:Jacobian_grpObj`,
  `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`,
  `thm:Jacobian_geomIrred`).
- `\subsection{Sanity check in low genus}` (g=0, g=1, g≥2 enumeration).

### MUST-FIX: expand `thm:nonempty_jacobianWitness` proof block

The current proof block (the `\begin{proof}` that follows the theorem
statement) bundles three classical constructions into one paragraph
and concedes Mathlib lacks all the inputs. The user directive
requires the proof block to be a **detailed mathematical exposition
that a future formalizer can attack**.

Rewrite the proof block as a structured three-route argument with
the following layout:

1. **Reduction**: state explicitly that the witness's underlying
   scheme `J` is intrinsic to `C` and that the dependence on the
   marked point `P` is confined to the universal morphism
   `\iota_P : C \to J`. The structure `JacobianWitness` encodes
   this via a single `J` field and a `\forall P, IsAlbanese C P J`
   field.

2. **Route A — Picard scheme**:
   - Sub-step A.1: the relative Picard functor
     `\mathrm{Pic}_{C/k}^{\sharp} : (\mathrm{Sch}/k)^{op} \to \mathrm{Set}`
     sending `T \mapsto \mathrm{Pic}(C_T) / \pi^* \mathrm{Pic}(T)`
     where `\pi : C_T \to T` is the projection.
   - Sub-step A.2: representability of `\mathrm{Pic}_{C/k}^{\sharp}`
     by a `k`-group scheme `\mathrm{Pic}_{C/k}`; FGA's main
     representability theorem applied to `C` smooth proper
     geometrically connected.
   - Sub-step A.3: `\mathrm{Pic}^0_{C/k}`, the identity component,
     is a smooth proper geometrically irreducible `k`-group scheme
     of dimension `g(C)`.
   - Sub-step A.4: for each `P \in C(k)`, the Abel-Jacobi morphism
     `\iota_P : C \to \mathrm{Pic}^0_{C/k}` sending `Q \mapsto
     \mathcal O_C(Q - P)` is universal among morphisms to abelian
     varieties sending `P` to the identity. This is the universal-
     property half.
   - Mathlib status: each sub-step is missing. Specifically:
     `Pic`-scheme representability requires Hilbert/Quot scheme
     infrastructure; `Pic^0` requires connectedness machinery for
     group schemes; the universal property uses the classical
     Albanese functoriality not yet in Mathlib.

3. **Route B — Symmetric powers and Stein factorisation**:
   - Sub-step B.1: form `C^g`, then `C^{(g)} := C^g / S_g` (the
     `g`-fold symmetric product); `C^{(g)}` is a smooth proper
     scheme of dimension `g(C)` over `k`.
   - Sub-step B.2: the natural map
     `\sigma : C^{(g)} \to \mathrm{Pic}^g_{C/k}` sending
     `\sum_i [Q_i] \mapsto \mathcal O_C(\sum_i Q_i)` is surjective
     and birational onto its image (Brill–Noether–Riemann–Roch);
     its fibres are projective spaces.
   - Sub-step B.3: the Stein factorisation
     `C^{(g)} \xrightarrow{\sigma_*} \mathrm{Spec}(\sigma_*
     \mathcal O_{C^{(g)}}) \to \mathrm{Pic}^g_{C/k}` yields a
     smooth proper geometrically irreducible scheme as the middle
     term; translating by `-g P_0` for a fixed `P_0 \in C(k)`
     produces `\mathrm{Pic}^0_{C/k}`.
   - Mathlib status: symmetric powers of schemes are not in
     Mathlib; finite-group scheme quotients (the `\cdot / S_g`
     construction) are not in Mathlib; the Stein factorisation
     theorem for proper morphisms of schemes is partially present
     but the surrounding cohomological machinery
     (`f_* \mathcal O_X` for `f` proper, with `\mathcal O`-modules
     of finite type) is not.

4. **Genus-0 sub-case (absorbed into the same witness)**:
   - Sub-step C.1: a smooth proper geometrically irreducible curve
     of genus `0` with a `k`-rational point is isomorphic to
     `\mathbb P^1_k` (Brauer–Severi triviality).
   - Sub-step C.2: every morphism `f : \mathbb P^1_k \to A` to a
     smooth proper geometrically irreducible group scheme `A` over
     `k` with `f(P) = \eta_A` is the constant morphism at
     `\eta_A`. This is the **rigidity theorem**
     `\mathrm{Hom}(\mathbb P^1_k, A) = A(k)` for morphisms to
     abelian varieties.
   - Sub-step C.3: take `J := \mathrm{Spec}\, k`, the trivial
     `k`-group scheme of dimension `0`; the unique morphism
     `\mathrm{Spec}\, k \to A` provides the required factorisation.
   - Mathlib status: the rigidity theorem is not in Mathlib in the
     form needed here; the Brauer–Severi reduction is partially
     available via Mathlib's projective-line theory but the
     genus-0 / `\mathbb P^1` identification on the curve side
     requires the genus definition + Serre duality which the
     project has explicitly trimmed.

5. **Mathlib infrastructure summary**: at the end of the proof
   block, name the three independent Mathlib infrastructure
   build-outs each of which would unlock one route:
   - **(α) Hilbert/Quot scheme + FGA representability** unlocks
     Route A.
   - **(β) Symmetric powers of schemes + finite-group scheme
     quotients + the proper-Stein-factorisation cohomology
     hypotheses** unlock Route B.
   - **(γ) `\mathrm{Hom}(\mathbb P^1_k, A) = A(k)` rigidity** is
     a prerequisite of the genus-0 sub-case under any route.

This expanded proof block is the chapter's contribution to the user
directive's "blueprints should be detailed enough" requirement: a
mathematician picking up the project in the future has, in this one
proof block, a structured map of the three classical proof routes,
each sub-step, and the named Mathlib gap blocking it.

### MUST-FIX: expand `thm:Jacobian_grpObj` and the four-instances proof sketches

Each of the four protected-instance theorems
(`thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`,
`thm:Jacobian_proper`, `thm:Jacobian_geomIrred`) currently has a
one-line "the Albanese construction" proof reference.

Rewrite each proof block to mirror the actual Lean implementation,
which projects each property from the corresponding field of
`JacobianWitness`:

- `thm:Jacobian_grpObj` proof:
  > By Definition~\ref{def:Jacobian},
  > $\Jac(C) = (\mathrm{jacobianWitness}\, C).J$ as a $k$-scheme.
  > The witness carries the group-object structure as the field
  > `grpObj : GrpObj J`, so $\Jac(C)$ inherits it by projection.
  > Mathematically: any Albanese variety carries a unique
  > group-object structure compatible with the universal pointed
  > morphism, by the standard Albanese argument
  > (Theorem~\ref{thm:IsAlbanese_unique}).

- Similarly for the other three. Each proof block should be a short
  paragraph naming (a) the field projection that closes the proof
  in Lean and (b) the mathematical content of the property.

### MUST-FIX: `def:IsAlbanese` typeclass-parameter disclosure

`def:IsAlbanese` currently states the universal property informally
but does NOT mention that the four conditions
(`[GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible
J.hom]`) are encoded as **typeclass parameters** of the Lean
declaration, not as conjuncts inside the body. Add a one-paragraph
remark or footnote stating: "The Lean encoding takes the four
abelian-variety conditions on `J` as typeclass parameters; a
downstream user constructs an `IsAlbanese` term against these
instances and threads them at every use site (cf. the `letI`
chain in `AbelJacobi.ofCurve`)."

## Out of scope

- Do NOT change the existing `def:IsAlbanese` informal statement or
  `thm:IsAlbanese_unique` proof — they are well-formed.
- Do NOT add new declaration blocks beyond what is named above.
- Do NOT remove the `\subsection{Sanity check in low genus}`.
- Do NOT modify any other chapter.
- Do NOT touch `content.tex`.
- Do NOT speculate about which of the three routes the project
  will choose; the project ships against the bundled hypothesis,
  not against a specific route.

## References

- `references/challenge.lean` — the original Christian Merten
  challenge file containing the protected signatures.
- The project's `STRATEGY.md` says: "this is the single explicit
  foundational hypothesis the project ships against. The blueprint
  chapter `Jacobian.tex` documents all three classical routes and the
  Mathlib infrastructure each requires; closure is a project-external
  Mathlib-build-out, not a within-loop autonomous task."
- Hartshorne III for Pic-scheme background; FGA Explained for the
  representability technicalities.

## Expected outcome

A chapter that is the textbook-quality reference document for the
project's one explicit foundational hypothesis. The `thm:nonempty_jacobianWitness`
proof block expands from ~10 lines to ~60–80 lines of structured
exposition. Total chapter length grows from ~130 lines to ~200–250
lines; nothing existing is deleted (modulo the minor revisions above).
