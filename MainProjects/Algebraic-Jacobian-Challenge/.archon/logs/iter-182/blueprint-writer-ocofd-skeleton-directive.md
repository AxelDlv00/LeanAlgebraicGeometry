# Blueprint Writer Directive — `ocofd-skeleton`

## Slug
ocofd-skeleton

## Iteration
182

## Scope

Create ONE new chapter: `blueprint/src/chapters/RiemannRoch_OcOfD.tex`.

This chapter blueprints the (currently-missing) Lean file
`AlgebraicJacobian/RiemannRoch/OcOfD.lean`, whose job is to define the
**invertible sheaf `O_C(D)`** for a smooth proper geometrically
irreducible curve `C / k̄` and a Weil divisor `D`. The Lean file will
be opened in iter-183 as a file-skeleton lane; this chapter sets up
the blueprint so the HARD GATE clears.

## Strategic context

- **Why this chapter is needed now**: `Scheme.WeilDivisor.sheafOf` at
  `AlgebraicJacobian/RiemannRoch/RRFormula.lean:168` is currently a
  typed-sorry `noncomputable def` with no chapter pinning. Multiple
  downstream chapters consume it:
  - `RiemannRoch_RRFormula.tex` — the χ-identity inductive proof
    consumes `sheafOf`'s body for both base case and inductive step
    (iter-181 Lane H landed 2 helper sorries gated on this).
  - `RiemannRoch_OCofP.tex` — `lineBundleAtClosedPoint` is the
    `D = [P]` specialisation of `sheafOf` (per the iter-182 analogist
    consult `ocofp-sheaf-internalhom`, the project's most viable path
    is Hartshorne's subsheaf-of-`K_C` direct construction).
  - `RiemannRoch_RationalCurveIso.tex` — Pin 2/Pin 3 both consume
    `sheafOf` via the function-field/Weil-divisor degree bridge.

- **iter-182 progress-critic verdict**: opening `OcOfD.lean` is a
  must-fix-this-iter unblock — five consecutive iters deferred work
  on a gate file that does not exist. The blueprint chapter MUST land
  this iter for the same-iter fast path to put `OcOfD.lean` in
  iter-183 objectives.

- **Out of scope**: actually creating the Lean file (iter-183 work).
  This chapter is statement-level for the file's eventual top decls.

## Chapter outline

Sections to write:

### §1 — Background and motivation (~30-50 lines)

The setting: smooth proper geometrically irreducible curve `C` over
algebraically closed field `k̄`; the Picard group; line bundles vs
Weil divisors (correspondence via Hartshorne II.6.18).

### §2 — Definition of `O_C(D)` (~80-120 lines)

Pin the load-bearing definition:

```latex
\begin{definition}[Invertible sheaf $\mathcal O_C(D)$]
  \label{def:sheafOf}
  \lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf}
  \uses{def:scheme_weil_divisor, def:scheme_function_field}
  % SOURCE: Hartshorne, II.6, "Cartier divisors", II.6.18
  % SOURCE QUOTE: <verbatim text from references/hartshorne-graduate.pdf>
  \textit{Source: Hartshorne, II.6.}
  For a Weil divisor $D = \sum n_Q [Q]$ on a smooth curve $C / \bar k$,
  the sheaf $\mathcal O_C(D)$ is the subsheaf of $\mathcal K_C$
  (the constant sheaf at the function field) given by
  $$\Gamma(U, \mathcal O_C(D)) = \{ f \in K(C) : \text{ord}_Q(f) \geq -n_Q
    \text{ for all prime divisors } Q \in U \}.$$
\end{definition}
```

Three immediate corollaries (all blueprint-pinned):

```latex
\begin{lemma}[Sheaf of $0$ is structure sheaf]
  \label{lem:sheafOf_zero}
  \lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_zero}
  $\mathcal O_C(0) = \mathcal O_C$ canonically as sheaves on $C$.
\end{lemma}

\begin{lemma}[Sheaf at a closed point is the iter-181 lineBundleAtClosedPoint]
  \label{lem:sheafOf_singlePoint}
  \lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_singlePoint}
  For a closed point $P$ on $C$,
  $\mathcal O_C([P]) = \text{lineBundleAtClosedPoint}_{P}$
  (the `OCofP.lean` construction).
\end{lemma>

\begin{lemma}[SES additivity]
  \label{lem:sheafOf_ses_additivity}
  \lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_ses_single_add}
  For any prime divisor $Y$ and any $n : \mathbb Z$:
  $$0 \to \mathcal O_C(D) \to \mathcal O_C(D + [Y]) \to k(Y)^{[\text{point at } Y]} \to 0$$
  is a short exact sequence (where the rightmost is the skyscraper sheaf at $Y$).
\end{lemma}
```

### §3 — Proof of correctness (~60-100 lines)

Sketch the construction at the presheaf level + the sheaf property:

1. **Presheaf**: $U \mapsto \{ f \in K(C) : \text{ord}_Q(f) \geq -n_Q
   \forall Q \in U \}$ with restriction by identity on $K(C)$.
2. **Sheaf property**: the order conditions are LOCAL at each prime
   divisor; gluing reduces to the local-ring property at each prime
   divisor's stalk (a DVR for a smooth curve over $\bar k$).
3. **Invertibility**: locally on `U \setminus \{Q\}`, the constraint
   on `ord_Q` vanishes; globally `O_C(D)` is locally free of rank 1.

### §4 — `\lean{...}` pins (~10-15 lines)

Each load-bearing declaration above carries a `\lean{...}` pin
naming the eventual top-level declaration in `OcOfD.lean`. The Lean
file's iter-183 file-skeleton lane will create exactly these
declarations as typed sorries.

## Reference retrieval

If `references/hartshorne-graduate.pdf` is not present, dispatch a
child `reference-retriever` to fetch it (your `--write-domain`
includes `references/**` for this). The `% SOURCE QUOTE:` blocks
require verbatim text from this source — do NOT paraphrase or
synthesize.

If the retrieval fails (paywall, NOT_FOUND), leave the SOURCE QUOTE
blocks flagged as `(verbatim text not yet retrieved)` per the
anti-fabrication rule and report the failure.

## Update `content.tex`

Insert a single `\input{chapters/RiemannRoch_OcOfD}` line in
`blueprint/src/content.tex` in the canonical position (after
`\input{chapters/RiemannRoch_OCofP}` and before
`\input{chapters/RiemannRoch_RRFormula}`).

## Out of scope

- Creating the Lean file `OcOfD.lean` (iter-183 work).
- Editing chapters other than `RiemannRoch_OcOfD.tex` and the single
  line update in `content.tex`.
- Adding `\leanok` / `\mathlibok` markers.
- Touching `archon-protected.yaml`.

## Strategy-modifying findings

Report back if you discover the construction route is structurally
different from Hartshorne's subsheaf-of-`K_C` description (which is
what the iter-182 analogist recipe for OCofP committed to). The
chapter must align with the iter-182 OCofP `analogies/ocofp-sheaf-internalhom.md`
recipe.
