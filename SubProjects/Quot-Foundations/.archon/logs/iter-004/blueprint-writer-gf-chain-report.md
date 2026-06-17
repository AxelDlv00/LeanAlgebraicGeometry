# Blueprint Writer Report

## Slug
gf-chain

## Status
COMPLETE — all three directive tasks done; leandag clean (0 isolated, 0 unknown_uses, 0 conflicts).

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Changes Made

### TASK 1 — L4 `lem:gf_noether_clear_denominators` re-encoded to explicit AlgHom target
- **Removed** the `% NOTE (iter-003 review)` block that asked for the (a)-vs-(b)
  decision (the planner decided (b)); replaced its role with a documented
  `% LEAN SIGNATURE` comment block.
- **Added** a `% LEAN SIGNATURE` comment block (modelled on the
  `% LEAN SIGNATURE HEADER` of `thm:generic_flatness`) recording the intended
  conclusion verbatim:
  `∃ (n : ℕ) (g : A) (_ : g ≠ 0) (φ : MvPolynomial (Fin n) (Localization.Away g) →ₐ[Localization.Away g] Localization.Away (algebraMap A B g)), Function.Injective φ ∧ (letI := φ.toAlgebra; Module.Finite (MvPolynomial (Fin n) (Localization.Away g)) (Localization.Away (algebraMap A B g)))`.
  The comment records: `A_g := Localization.Away g`, `B_g := Localization.Away (algebraMap A B g)`;
  the subalgebra `A_g[b_1,…,b_n]` realised as the domain `MvPolynomial (Fin n) A_g`
  with `b_j = φ(X_j)`; that the single `φ` replaces the anonymous instance
  existentials (`Function.Injective φ` = algebraic independence, `Module.Finite … over φ.toAlgebra` = module-finiteness);
  why `B_g` not `B` (one inversion `g` clears the integral-dependence denominators);
  and the L5 downstream consumption via `φ.toAlgebra`.
- **Revised** the visible prose statement: now states the existence of `φ : A_g[X_1,…,X_n] → B_g`,
  an injective `A_g`-algebra homomorphism with `B_g` module-finite over the image
  polynomial subalgebra via `φ`. Names `A_g`, `B_g` explicitly.
- **Revised** the proof's closing sentence to construct `φ` (sending `X_j ↦ b_j`),
  noting injectivity = algebraic independence and finiteness = finiteness over `im φ`.
- Kept the `% SOURCE` / `% SOURCE QUOTE PROOF` Nitsure §4 quotes verbatim.

### TASK 2 — `lem:gf_free_moduleFinite` prose corrected
- **Removed** the `% NOTE (iter-003 review)` flag.
- **Restated** the statement body with the actual hypotheses: `A` noetherian domain,
  `B` module-finite `A`-algebra (`[Module.Finite A B]`), `M` finite `B`-module
  (`[Module.Finite B M]`) with scalar tower `A → B → M`; conclusion unchanged.
- **Rewrote** the proof: `A`-finiteness of `M` is now shown to be *derived* via
  `Module.Finite.trans B M` (not assumed), then `lem:gf_finite_module` is applied.
  Removed the misleading "Identical to lem:gf_finite_module" phrasing and added an
  explicit note that the lemma is strictly more general.

### TASK 3 — L3 `lem:gf_splice_shortExact` effort-broken into a 3-sub-lemma chain
- **Added** `lem:gf_splice_shortExact_localized_exact` (L3a, localised SES is exact)
  — `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}`,
  statement + informal proof (localisation is exact; cites `LocalizedModule.map_exact`
  direction on the scalar-restricted maps). `\uses{}` empty (no external source quote — bespoke plumbing).
- **Added** `lem:gf_splice_shortExact_free_transport` (L3b, free transport across a
  finer localisation) — `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}`,
  statement (`f = f'f''`, `N_{f'}` free over `A_{f'}` ⟹ `N_f` free over `A_f`) + proof
  (localisation of a free module is free). Standalone so it is reused for both ends.
- **Added** `lem:gf_splice_shortExact_split` (L3c, SES with free ends has free middle)
  — `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}`,
  statement + proof (free quotient ⟹ projective ⟹ split ⟹ `M_f ≅ M'_f ⊕ M''_f` free).
- **Revised** parent assembly `lem:gf_splice_shortExact` — renamed human label to
  "(assembly)", kept its `\lean{}` pin and the verbatim Nitsure §4 splicing
  `% SOURCE QUOTE PROOF` on the statement. Added
  `\uses{lem:gf_splice_shortExact_localized_exact, …_free_transport, …_split}` on the
  statement block (and mirrored on the proof, matching the project's existing
  dual-`\uses` convention for `gf_flat_finite`/`gf_free_moduleFinite`). Rewrote the
  proof as the assembly: pick `f := f'f''` (`f ≠ 0`), apply L3a → localised SES,
  L3b twice → both ends free, L3c → free middle.

## Cross-references introduced
- `\uses{lem:gf_splice_shortExact_localized_exact, lem:gf_splice_shortExact_free_transport, lem:gf_splice_shortExact_split}`
  on `lem:gf_splice_shortExact` (statement + proof) — all three targets are new blocks in this same chapter.
- L5 `lem:gf_polynomial_core` keeps `\uses{… lem:gf_splice_shortExact …}` (parent label
  remains the consumer-facing edge, per directive); `thm:generic_flatness_algebraic`
  likewise still `\uses{… lem:gf_splice_shortExact …}`. Unchanged.
- leandag verification: `unknown_uses: []`, `conflicts: []`, `isolated: 0`, edges
  100 → 103 (the three new sub-lemmas wired in).

## References consulted
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (L1705–1787) — re-read to
  confirm the verbatim `% SOURCE QUOTE PROOF` text for the splicing fact (L1737–1745,
  carried onto the parent assembly) and the Noether-normalisation step (L1747–1758, kept on L4)
  matches the existing in-chapter quotes character-for-character. No quote text changed.
- `references/summary.md` — confirmed Nitsure is the primary source backing this chapter.

## Macros needed (if any)
- None. New prose uses only existing macros (`\OO`, `\Spec`, standard amsmath) and `\texttt{}` for Lean names.

## Reference-retriever dispatches (if any)
- None. The Nitsure source already on disk covered everything; no new external material needed.

## Notes for Plan Agent
- The three new L3 sub-lemmas pin to to-be-created Lean decls in the
  `AlgebraicGeometry.GenericFreeness` namespace (names chosen descriptively; the
  prover/scaffolder creates them):
  `exact_localizedModule_powers_of_shortExact`, `free_localizationAway_of_free_of_eq_mul`,
  `free_of_shortExact_of_free_free`. These now show as blueprint nodes without a matching
  Lean decl — expected until the scaffold/prover pass lands them.
- L4's `\lean{}` pin (`exists_localizationAway_finite_mvPolynomial`) is unchanged; the
  directive asked only to document/re-encode the *intended target signature* in a
  `% LEAN SIGNATURE` comment + prose, not to rename the decl. The prover will re-sign the
  existing decl to the AlgHom form recorded in the comment block.
- No `\mathlibok` anchor was added for L3a's `LocalizedModule.map_exact` direction: I could
  not confirm the exact Mathlib name from the sources available this session, so per the
  directive's instruction I left it as a prose pointer for the prover rather than fabricate
  a Mathlib anchor.

## Strategy-modifying findings
None. The decomposition and re-encodings are presentation/Lean-ergonomics changes; the
underlying mathematics and the chapter's role in the strategy are unchanged.
