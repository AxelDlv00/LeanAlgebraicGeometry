# Blueprint-clean report — bc264

**Status:** Complete. All Lean leakage stripped; mathematical content preserved; named-lemma proof-sketch hints retained.

---

## Cohomology_CechHigherDirectImage.tex

**Proof of `lem:push_pull_functor` (bw-cech264 functor-law block):**

Three pieces of Lean-specific content removed:

1. Argument-pinning parentheticals `(at X := Y.left, f := p)` and `(at f := \bar h, g := \bar g, h := p_1)` deleted from the identity-law and composition-law paragraphs respectively. These are Lean elaboration hints, not mathematics.

2. The phrase "and the reduced definitional-transparency setting (`backward.isDefEq.respectTransparency false`) under which the unitor lemmas are stated" was deleted. A Lean elaboration option belongs in code, not in a mathematical blueprint.

3. The tactic instruction "The coercion-glued composites must be written as fully-applied forward terms with explicit `congrArg` proofs; a naive goal split into subgoals fails" was deleted. This is implementation guidance for a Lean proof, not a mathematical statement.

Named-lemma references retained: `conjugateEquiv_pullbackComp_inv`, `conjugateEquiv_pullbackId_hom`, `pseudofunctor_right_unitality`, `pseudofunctor_associativity`, `Adjunction.unit_naturality`. These read as named-lemma references in prose and were intentional prover guidance; they were left intact.

The `sec:cech_three_part` dependency-claim correction (bw-cech264) and all `\lean{}` pins were already correctly formatted and required no cleaning.

---

## Picard_TensorObjSubstrate.tex

**Proof of `lem:pullback_tensor_map_basechange` — Sq1 tail (bw-tos264):**

The "reduced tail goal" block was replaced. The original contained:
- A displayed equation in Lean proof-state notation (`B_{h∘f}.unit.app P = sheafAdj_X.unit P ; (forget ∘ restrictScalars).map (U ; pushforward(h∘f).map (R_1 ; R_5 ; δ_pre))`) with auxiliary abbreviations `B_φ`, `U`, `R_1`, `R_5`, `δ_pre` defined by Lean API term composition — a Lean proof state dump, not mathematics.
- A "Dead-end (do not pursue)" paragraph recording a failed proof route — project history, not mathematics.

Both were replaced by a concise prose paragraph preserving the mathematical content: the unit identity for the composite adjunction, recovery of sub-comparison units via `homEquiv_leftAdjointUniq_hom_app`, and reassembly via unit-naturality of `pushforwardComp` and `pullbackComp`.

**Proof of `lem:slice_dual_transport` — naturality/invFun/map_smul' (bw-tos264):**

Two Lean-API-dump phrases were cleaned:

1. Leg (A): "The reindexing is built as the functorial image under `restrictScalars β_W`: a genuine change-of-rings functor acts here, so the map is applied categorically via `.map`." — The instruction "so the map is applied categorically via `.map`" is a Lean API call instruction; deleted. The preceding mathematical description (reindexing built as functorial image under `restrictScalars β_W`) was already adequate.

2. Step (ii) of the linearity proof: "To let `map_smul` fire on the reindexed component one must in addition unfold the `restrictScalars` scalar action by `ModuleCat.restrictScalars.smul_def'`" — the phrasing "to let `map_smul` fire" is Lean tactic language. Replaced by: "The restricted scalar action is made explicit by `ModuleCat.restrictScalars.smul_def'`", preserving the named-lemma reference as required.

Named-lemma references retained throughout: `homEquiv_leftAdjointUniq_hom_app`, `sheafificationCompPullback_comp_tail`, `pushforwardComp`, `pullbackComp`, `ModuleCat.restrictScalars.smul_def'`, `InternalHom.termRingMap_naturality`, `Subsingleton.elim`. All `\lean{}` hints preserved unchanged.

---

## SOURCE / SOURCE QUOTE blocks

All pre-existing `% SOURCE` and `% SOURCE QUOTE` blocks in both chapters are intact and correctly formatted. No new external sources were introduced by bw-cech264 or bw-tos264 (both chapters' new content is project-bespoke), so no reference retrieval was needed.
