# Blueprint-clean report — iter-007

## Cohomology_FlatBaseChange.tex

### What was stripped / fixed

All changes are confined to the proof body of `lem:base_change_mate_regroupEquiv`
(the newly-rewritten proof). Nine targeted edits were made to the visible prose:

1. **"morphism of the precise `\texttt{ModuleCat}` carriers the section-level computation
   produces"** → **"morphism of $R'$-module objects"** — removed Lean type name from
   the opening sentence.

2. **"We work in the Lean orientation $A \otimes_R R'$ ... up to `\texttt{TensorProduct.comm}`"**
   → **"We work in the $A \otimes_R R'$ orientation ... up to the canonical commutativity
   isomorphism, per the tensor-order convention note"** — removed the Lean-specific
   label "Lean orientation" and the Lean identifier `TensorProduct.comm`.

3. **"`\texttt{Algebra.TensorProduct}` $A$-action"** → **"$A$-action"** — removed a
   spurious Lean namespace qualifier from the description of the canonical A-action.

4. **"coincide as values, but the $A$-module is an instance argument of the relative
   tensor product ... not even across a compilation boundary, since the boundary normalises
   the value-level `\texttt{Module }A` diamond but never the tensor type itself"**
   → **"coincide on elements, but the tensor product depends on the $A$-module structure
   in its type, so the two tensor products are not equal even though their underlying
   abelian groups are the same"** — replaced Lean typeclass-instance implementation
   language ("instance argument", "compilation boundary", "Module A diamond") with a
   pure mathematical statement.

5. **"`\texttt{ModuleCat}` objects. We verify this on generators, keeping each generator
   ... typed at the full carrier object, so that the instance in play is the object's own
   $R'$-module structure — the one coming from
   $\operatorname{restr}_{\psi'} \circ \operatorname{extendScalars}$ along ..."**
   → **"$R'$-module structures. We verify this on generators; the $R'$-action on the
   carrier is restriction of scalars along $R' \to A \otimes_R R'$, ..."** — removed
   typeclass-instance language ("typed at the full carrier object", "instance in play",
   "object's own") while preserving the mathematical content (the explicit formula for
   the $R'$-action).

6. **"helper's underlying map factors as `\texttt{comm}` → `cancelBaseChange` →
   `\texttt{comm}` and sends"** → **"helper's underlying map sends"** — removed the
   Lean function-chain prescription (the factorisation detail); the sending formula and
   reference to `lem:base_change_regroup_linearEquiv` are retained.

7. **"hence everywhere by `\texttt{TensorProduct.induction\_on}`"** → **"hence everywhere
   by bilinearity"** — replaced the Lean lemma name with the mathematical principle it
   invokes.

8. **"desired bundled $R'$-linear `\texttt{ModuleCat}` isomorphism"** → **"desired
   bundled $R'$-linear isomorphism"** — removed Lean type name.

9. **Entire "recommended formalization" paragraph removed** (original lines 1322–1335):
   The paragraph prescribing a specific Lean tactic chain
   (`restrictScalars.smul_def → ExtendScalars.smul_tmul → Algebra.TensorProduct.tmul_mul_tmul`,
   the `comm/cancelBaseChange_tmul/comm` simp set, "fires against the transparent
   $R'$-instance", the fallback `ModuleCat`-level Beck–Chevalley isomorphism) was pure
   Lean code leakage. Retained only the mathematical conclusion: "Being a composite of
   linear equivalences the result is an $R'$-linear isomorphism, and none of its
   constituents carries a flatness hypothesis."

The three new sub-lemmas (`lem:base_change_mate_unit_value`,
`lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose`) and the
rewritten `lem:base_change_mate_generator_trace_eq` have no Lean tactic leakage in their
visible prose. The `% LEAN SIGNATURE`, `% NOTE`, and `% ---` structural comments are left
intact as required.

### SOURCE quote validation

- **`lem:base_change_mate_generator_trace_eq`** — SOURCE QUOTE:
  > "Thus we see that the lemma boils down to the equality $(R' \otimes_R A) \otimes_A M
  > = R' \otimes_R M$ as $R'$-modules."

  Verified verbatim against `references/stacks-coherent.tex` L932–937. ✓

- **`lem:base_change_mate_unit_value`**, **`lem:base_change_mate_fstar_reindex`** —
  No external citation; both are internal infrastructure lemmas that stand on their
  proof sketches (per the `% NOTE` on `lem:base_change_mate_gstar_transpose`).

- **`lem:base_change_mate_gstar_transpose`** — `% NOTE` in the block explicitly states
  "stands on its proof sketch with no external reference." No SOURCE block is required
  or missing.

All pre-existing SOURCE QUOTE blocks (for `lem:affine_base_change_pushforward`,
`lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`,
`lem:base_change_mate_regroupEquiv`, `lem:pushforward_base_change_mate_cancelBaseChange`,
`thm:flat_base_change_pushforward`) were not touched and remain verbatim.

### Structural integrity

- No `\uses{}`, `\label{}`, or `\lean{}` edges were altered.
- No `\leanok` / `\mathlibok` markers were added or removed.
- `lem:base_change_mate_regroupEquiv` retains its `\leanok`; the three new sub-lemmas
  remain unmarked (they have not been formalized).

---

## Picard_FlatteningStratification.tex

### What was stripped / fixed

**No changes were needed.** The new sub-lemmas added this iteration —
`lem:gf_generic_rank_ses`, `lem:gf_torsion_reindex`, `lem:gf_clear_one_denominator` —
contain no Lean tactic syntax or code leakage in their visible prose. The rewrites of
`lem:gf_polynomial_core` (L5) and `lem:gf_noether_clear_denominators` (L4) are also
clean:

- `% LEAN SIGNATURE` and `% LEAN PROOF STRUCTURE (iter-007)` comment blocks are intact
  per the directive.
- `% NOTE (shared engine)`, `% NOTE (iter-007 decomposition)`, and
  `% NOTE (resolved iter-006)` are structural decision comments in `%` blocks — not
  visible text — and are kept per the directive.
- No "iter-NNN" references appear in visible (non-comment) prose.
- No Lean tactic names, simp chains, or typeclass-instance language appear in visible
  prose.

### SOURCE quote validation

All source quotes for new sub-lemmas verified verbatim against
`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`:

- **`lem:gf_clear_one_denominator`** — SOURCE QUOTE PROOF:
  > "If $g\ne 0$ in $A$ is chosen to be a 'common denominator' for coefficients of
  > equations of integral dependence satisfied by a finite set of algebra generators
  > for $K\otimes_AB$ over $K[b_1,\ldots, b_n]$, we see that $B_g$ is finite over
  > $A_g[b_1,\ldots, b_n]$."

  Verified verbatim against L1755–1759. ✓

- **`lem:gf_generic_rank_ses`** — SOURCE QUOTE PROOF:
  > "Let $m$ be the generic rank of the finite module $B_g$ over the domain
  > $A_g[b_1,\ldots, b_n]$. Then we have a short exact sequence of
  > $A_g[b_1,\ldots, b_n]$-modules of the form $0\to A_g[b_1,\ldots, b_n]^{\oplus m}
  > \to B_g \to T \to 0$ where $T$ is a finite torsion module over
  > $A_g[b_1,\ldots, b_n]$."

  Verified verbatim against L1761–1765. ✓

- **`lem:gf_torsion_reindex`** — SOURCE QUOTE PROOF:
  > "Therefore, the dimension of the support of $K\otimes_{A_g}T$ as a
  > $K\otimes_{A_g}(B_g)$-module is strictly less than $n$. Hence by induction on $n$
  > (applied to the data $A_g$, $B_g$, $T$),"

  Verified verbatim against L1766–1768. ✓

- **`lem:gf_noether_clear_denominators`** SOURCE QUOTE PROOF
  ("By Noether normalisation lemma, there exist elements $b_1,\ldots,b_n \in B$...")
  verified against L1747–1758. ✓

- **`lem:gf_polynomial_core`** SOURCE QUOTE PROOF
  ("Let $m$ be the generic rank of the finite module $B_g$...")
  verified against L1760–1772. ✓

### Structural integrity

- No `\uses{}`, `\label{}`, or `\lean{}` edges were altered.
- No `\leanok` / `\mathlibok` markers were added or removed.
- `lem:gf_noether_clear_denominators` and `lem:gf_polynomial_core` retain their
  `\leanok` from prior iters. The three new sub-lemmas (`lem:gf_generic_rank_ses`,
  `lem:gf_torsion_reindex`, `lem:gf_clear_one_denominator`) remain unmarked.
