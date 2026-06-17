# Blueprint Writer Report

## Slug
jacobian-descent

## Status
COMPLETE — every over-k-commitment assertion in Jacobian.tex rewritten to the
"rigidity over k̄ + faithfully-flat descent to k" picture; descent engine
`AlgebraicGeometry.Flat.epi_of_flat_of_surjective` cited with a proof sketch.

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made
All edits are prose-only inside pre-existing environments — no `\begin`/`\end`
added or removed (count stays 39/39), no `\leanok`/`\mathlibok` touched, no
protected signatures or `\lean{}` hints changed.

- **Revised** intro paragraph of `thm:nonempty_jacobianWitness` proof — the
  genus-0 sub-case now "routes through `thm:rigidity_over_kbar` (rigidity over
  k̄ = AlgebraicClosure k) and then *descends* the morphism equality from k̄ to
  k along the faithfully-flat surjection Spec k̄ → Spec k". Replaced the
  "directly over k per the iter-127 over-k commitment" assertion.

- **Revised** Sub-step C.2 framing — last sentence now states the over-k
  conclusion "follows by descent: a morphism equality holding after base change
  to k̄ descends to k along the faithfully-flat surjection (Sub-step C.2.f)",
  replacing "follows by Galois descent". Kept the (correct) "state rigidity over
  k̄" framing of the rest of C.2 intact.

- **Rewrote** Sub-step C.2.f entirely — was "[DROPPED iter-127] Galois descent
  to k — no longer needed". Now "Descent of morphism equality from k̄ to k":
  full ~2-line proof sketch — base-change f, c to f_{k̄}, c_{k̄}; base-change
  squares q∘f_{k̄}=f∘p and q∘c_{k̄}=c∘p; from f_{k̄}=c_{k̄} get f∘p=c∘p; the
  projection p : C_{k̄} → C is the base change of the faithfully-flat surjection
  Spec k̄ → Spec k, hence faithfully flat + surjective, hence an epimorphism by
  `AlgebraicGeometry.Flat.epi_of_flat_of_surjective`; right-cancel p ⟹ f=c over
  k. Noted it is cheaper than the proper-cohomology flat-base-change machinery.

- **Rewrote** Sub-step C.2.g — was "Mathlib gap statement (iter-127 over-k
  inventory)" asserting the signature is "k-agnostic ([Field kbar], no
  [IsAlgClosed kbar])" and that Galois descent "is eliminated". Now: keystone
  stated over an algebraically closed k̄; `thm:rigidity_over_kbar` "now carries
  [IsAlgClosed k̄]"; pile pieces (i)–(iii) restated over k̄; descent step C.2.f
  flagged as NOT a Mathlib gap but a short consequence of
  `epi_of_flat_of_surjective` + base-change-square commutativity.

- **Revised** the genus-0 "Mathlib status" bullet (after Route B status) — pile
  inventory now (i)+(ii)+(iii) over k̄; descent C.2.f described as a short
  consequence of `epi_of_flat_of_surjective`, replacing "Galois descent … no
  longer a prerequisite … C.2.f is DROPPED".

- **Revised** infrastructure-summary item (γ) — header "over an arbitrary base
  field k" → "over an algebraically closed field k̄"; signature "[IsAlgClosed
  k̄]"; pile pieces over k̄; `genusZeroWitness` now described as base-changing
  (C,A,f,P) to k̄ (genus stable under base change for a geometrically
  irreducible curve), applying rigidity over k̄, then descending to k via
  C.2.f. Dropped the stale `analogies/cotangent-vanishing-pile-over-k.md`
  citation.

- **Revised** `def:genusZeroWitness` proof, *Existence* clause — replaced
  "content of `thm:rigidity_over_kbar` … established directly over k per the
  iter-127 over-k commitment" with the full base-change-and-descend argument:
  base-change C,A,f,P to k̄; rigidity over k̄ (now [IsAlgClosed k̄]) gives
  f_{k̄} constant; descend along p (epimorphism by
  `epi_of_flat_of_surjective`) to f = toUnit C ∘ η_A over k. The *Uniqueness*
  and *Vacuity* clauses are untouched (pointed-vs-unpointed spine preserved).

- **Revised** Layer-I prose (§ "Implementation route via the Albanese functor")
  — rigidity "established directly over k … no base-change to k̄ and no Galois
  descent" → rigidity over k̄ ([IsAlgClosed k̄]) + descent of the morphism
  equality along the faithfully-flat surjection (short consequence of
  `epi_of_flat_of_surjective`); universal factorisation "reduces to
  `thm:rigidity_over_kbar` over k̄ followed by descent to k".

## Cross-references introduced
- No new `\uses{}` labels added. `def:genusZeroWitness` and
  `thm:nonempty_jacobianWitness` already `\uses{thm:rigidity_over_kbar}`. The
  descent engine `AlgebraicGeometry.Flat.epi_of_flat_of_surjective` is a Mathlib
  lemma (not a blueprint label), so it is cited in prose only — no `\uses` entry.
- Existing `\cref{thm:rigidity_over_kbar}`, `\cref{chap:RigidityKbar}`,
  `\cref{thm:nonempty_jacobianWitness}`, `\cref{sec:RigidityKbar_shared_pile}`
  references are preserved and remain valid.

## References consulted
- (None for citation blocks.) The two affected proof sketches are
  Archon-original / Mathlib-citation content (the descent argument), so no
  `% SOURCE:`/`% SOURCE QUOTE:` blocks were written or altered. The Kleiman and
  Mumford citation blocks already present in the chapter were left byte-for-byte
  unchanged.
- `references/summary.md` — read to confirm no descent/flat-base-change source
  needed bundling; the descent is a single named Mathlib lemma.
- Verified `AlgebraicGeometry.Flat.epi_of_flat_of_surjective` exists via
  leansearch: `(f : X ⟶ Y) [Flat f] [Surjective f] : Epi f`, in
  `Mathlib.AlgebraicGeometry.Morphisms.Flat`. Spelling in the chapter matches.

## Macros needed (if any)
- None. All new prose uses existing commands (`\Spec`, `\bar k`, `\mathrm`,
  `\texttt`, `\cref`, `\emph`). `$\bar k$` and `\mathrm{AlgebraicClosure}` are
  already used elsewhere in the chapter.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- **Cross-chapter inconsistency (RigidityKbar.tex):** the `\paragraph{Iter-127
  over-k commitment.}` block at `RigidityKbar.tex:14` still asserts the *old*
  picture verbatim — "The Lean declaration's signature is already k-agnostic
  ([Field kbar], no [IsAlgClosed kbar])" and "The Galois-descent step M2.c …
  are DROPPED". This now directly contradicts the pivot (rigidity_over_kbar
  gains [IsAlgClosed kbar]; descent is restored). `RigidityKbar.tex` also has
  later `% NOTE:` comments (≈ lines 2089–2144, 2284) discussing a *user gate on
  adding [IsAlgClosed kbar]* and `IsAlgClosed.algebraMap_bijective_of_isIntegral`
  — those appear to anticipate the pivot, but the header prose was not updated.
  Recommend dispatching a blueprint-writer for `RigidityKbar.tex` to align its
  framing (and the C.2.* proof-decomposition prose) with the new [IsAlgClosed]
  signature. Out of my write-domain, so flagged only.
- **Other chapters matching `rigidity_over_kbar`/`kbar`:** `Rigidity.tex`,
  `AbelJacobi.tex`, and `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` also
  reference the rigidity declaration. They should be skimmed for stale "over k"
  / "no descent" framing inherited from the iter-127 commitment.
- **Lean-side note:** `genusZeroWitness`'s body must now actually perform the
  base-change-and-descend (build C_{k̄}, A_{k̄}, invoke rigidity_over_kbar over
  k̄, apply `epi_of_flat_of_surjective`). The blueprint sketch matches the
  ~2-line strategy-critic estimate for the descent *given* f_{k̄}=c_{k̄}, but
  the base-change plumbing (constructing the squares, transporting genus/proper/
  smooth/geomIrred and the pointing along base change) is additional Lean work
  beyond the 2 lines. Worth a prover objective scoped explicitly.

## Strategy-modifying findings
- None. The pivot as described in the directive is internally consistent: genus
  is stable under base change to k̄ for a geometrically irreducible curve, the
  hypotheses of `rigidity_over_kbar` (smooth/proper/geomIrred/genus-0, pointed)
  all transport along the base change Spec k̄ → Spec k, and
  `epi_of_flat_of_surjective` discharges the descent. No gap surfaced that would
  require editing STRATEGY.md beyond what the directive already commits.
