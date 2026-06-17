# Blueprint-writer directive — GF dévissage chapter (L3 break + L4 re-encode + prose fix)

## Chapter

`blueprint/src/chapters/Picard_FlatteningStratification.tex` — the
`GenericFreeness` dévissage chain (subsection "Dévissage chain for the
finite-type residue" and "Supporting finite-module helpers").

You edit ONLY this chapter. Three precise, independent tasks. Do all three.

---

## TASK 1 — Re-encode L4 `lem:gf_noether_clear_denominators` to an explicit AlgHom target

The current Lean signature (and the prose) existentially bind anonymous
algebra-instance witnesses — flagged fragile by both the lean-vs-blueprint
checker (major 1) and the lean-auditor. The planner has DECIDED on option (b):
re-state with an explicit algebra homomorphism. Implement that decision.

Add a `% LEAN SIGNATURE` comment block to the `lem:gf_noether_clear_denominators`
block (on the model of the `% LEAN SIGNATURE HEADER` that `thm:generic_flatness`
carries) specifying the intended target as:

```
∃ (n : ℕ) (g : A) (_ : g ≠ 0)
  (φ : MvPolynomial (Fin n) (Localization.Away g)
        →ₐ[Localization.Away g] Localization.Away (algebraMap A B g)),
  Function.Injective φ ∧
  (letI := φ.toAlgebra;
   Module.Finite (MvPolynomial (Fin n) (Localization.Away g))
                 (Localization.Away (algebraMap A B g)))
```

Notes to record in the block (as prose / `% LEAN SIGNATURE` commentary):
- `A_g := Localization.Away g`, `B_g := Localization.Away (algebraMap A B g)`.
- The polynomial subalgebra `A_g[b_1,…,b_n]` is realized as the *domain*
  `MvPolynomial (Fin n) A_g`, embedded into `B_g` by the algebra map `φ`; the
  generators `b_j` are `φ(X_j)`. This eliminates the anonymous instance
  existentials: the single `φ` carries the algebra structure, `Function.Injective φ`
  encodes algebraic independence, and `Module.Finite … over φ.toAlgebra` encodes
  module-finiteness of `B_g` over `A_g[b̄]`.
- Why `B_g` rather than `B`: generic flatness only needs the property after one
  inversion `g`; the integral-dependence equations only clear denominators after
  inverting `g` (see the existing SOURCE QUOTE PROOF — keep it verbatim).
- Downstream consumer: L5 `lem:gf_polynomial_core` applies to a finite module over
  `MvPolynomial (Fin n) A_g`; the AlgHom form hands it exactly that algebra
  structure via `φ.toAlgebra` with no instance-revival gymnastics.

Keep the existing `% SOURCE` / `% SOURCE QUOTE PROOF` Nitsure §4 quotes verbatim.
Update the visible prose statement so it matches the AlgHom encoding (name `φ`,
say `B_g` is module-finite over the image polynomial subalgebra via `φ`). Remove
the now-superseded `% NOTE (iter-003 review)` that asked for this decision (it is
being acted on); you may replace it with a one-line `% LEAN SIGNATURE` pointer.

## TASK 2 — Correct L `lem:gf_free_moduleFinite` prose

The prose understates the actual hypotheses (checker major 2). Restate the lemma
body as:

> For `A` a noetherian domain, `B` a module-finite `A`-algebra
> (`[Module.Finite A B]`), and `M` a finite `B`-module (`[Module.Finite B M]`)
> with the compatible `A`-module structure via the scalar tower `A → B → M`,
> there exists `f ≠ 0` such that `LocalizedModule (Submonoid.powers f) M` is free
> over `Localization.Away f`.

Make clear in the proof that `A`-finiteness of `M` is **derived** (via
`Module.Finite.trans B M`), not assumed, so the lemma is strictly more general
than a repackaging of `lem:gf_finite_module`. Remove the misleading "identical to
lem:gf_finite_module" phrasing and the `% NOTE (iter-003 review)` that flagged
this (it is being acted on).

## TASK 3 — Effort-break L3 `lem:gf_splice_shortExact` into a 3-sub-lemma chain

L3 (the SES splicing fact) is mathematically short but the Lean cost is real
module-side localization plumbing. Decompose `lem:gf_splice_shortExact` into the
following three `\uses`-linked sub-lemmas, each with its own `\label`, a
`\lean{}` pin naming a to-be-created Lean decl in the `GenericFreeness`
namespace (use descriptive names; the prover will create the decls), `\uses{}`,
a statement, and an informal proof. Keep the parent
`lem:gf_splice_shortExact` block as the **assembly** that `\uses` the three
sub-lemmas (it stays pinned to
`AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact`).

Carry the Nitsure §4 splicing `% SOURCE QUOTE PROOF` (currently on the parent)
onto the parent assembly; the sub-lemmas are project-internal Lean plumbing and
need no external source quote (they are bespoke localization lemmas).

- **L3a — localised SES is exact.** Given a short exact sequence
  `0 → M' →[i] M →[q] M'' → 0` of `B`-modules and `f ∈ A`, `f ≠ 0`, localising at
  `Submonoid.powers f` (restricting scalars to `A` first) yields an exact
  sequence `0 → M'_f → M_f → M''_f → 0` of `A_f`-modules (localised `i`
  injective, localised `q` surjective). Informal proof: localisation is exact;
  cite the API direction `LocalizedModule.map_exact` on `i.restrictScalars A`,
  `q.restrictScalars A`. `\uses{}` empty (or the exactness Mathlib fact if you add
  a `\mathlibok` anchor — optional, your call; do NOT invent a Mathlib name you
  cannot confirm).

- **L3b — free transport across a finer localisation.** If `M'_{f'}` is free over
  `A_{f'}` and `f = f' f''`, then `M'_f` is free over `A_f`. Informal proof:
  `M'_f` is the further localisation of the free `A_{f'}`-module `M'_{f'}` at the
  image of `f''`; a localisation of a free module is free. The Lean cost is
  building the module-side localisation map `M'_{f'} → M'_f` and its
  `IsLocalizedModule` instance (the prover's recipe: `Module.free_of_isLocalizedModule`
  with the ring-side `IsLocalization.Away.mul` transitivity). State it as a
  standalone sub-lemma so the prover closes the plumbing once and reuses it for
  both `M'` and `M''`.

- **L3c — SES with free quotient splits to a free middle.** A short exact
  sequence `0 → M'_f → M_f → M''_f → 0` of `A_f`-modules with both ends free
  (hence `M''_f` projective) splits, so `M_f ≅ M'_f ⊕ M''_f` is free. Informal
  proof: projective quotient ⟹ the sequence splits; a finite direct sum of free
  modules is free.

- **Parent assembly `lem:gf_splice_shortExact`:** pick `f := f' f''`
  (`f ≠ 0` by `mul_ne_zero`), apply L3a to get the localised SES, L3b (twice) to
  make both ends free over `A_f`, then L3c to conclude `M_f` free.
  `\uses{lem:gf_splice_shortExact_localized_exact, …_free_transport, …_split}`
  (use whatever labels you chose for L3a/L3b/L3c).

Update any block whose `\uses` referenced `lem:gf_splice_shortExact` only if the
dependency genuinely now flows through a sub-lemma — otherwise leave the parent
label as the consumer-facing edge (L5 `lem:gf_polynomial_core` should keep
`\uses{… lem:gf_splice_shortExact …}`).

---

## Global constraints

- You edit ONLY `blueprint/src/chapters/Picard_FlatteningStratification.tex`.
- NEVER add or remove `\leanok` (the deterministic `sync_leanok` phase owns it).
  Do not write "add \leanok" anywhere.
- `\mathlibok` only on genuine Mathlib dependency anchors, with a confirmed
  `\lean{}` Mathlib name. Do not fabricate Mathlib names; if unsure whether a
  Mathlib lemma exists, state the fact in prose without an anchor and leave it
  for the prover.
- Preserve all existing verbatim `% SOURCE` / `% SOURCE QUOTE PROOF` comments;
  move them to the correct (sub-)lemma when you split a block.
- If you need source material not already in `references/`, you may spawn a
  reference-retriever (your write-domain includes `references/**`). The Nitsure
  source is already at `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`.
- Keep prose mathematical — no Lean tactic strings in the prose bodies (the
  `% LEAN SIGNATURE` comment block is the one place a Lean type signature is
  appropriate, as a comment).
