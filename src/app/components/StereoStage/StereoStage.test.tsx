import { render } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { StereoStage } from "./StereoStage";

describe("<StereoStage />", () => {
	function subject() {
		return render(
			<StereoStage>
				<h1>Hello</h1>
			</StereoStage>,
		);
	}

	it("renders the children once per eye", () => {
		const { container } = subject();
		expect(container.querySelectorAll("h1")).toHaveLength(2);
	});

	it("keeps the right eye out of focus and accessibility", () => {
		const { container } = subject();
		expect(container.querySelector('[data-eye="right"]')).toHaveAttribute(
			"inert",
		);
	});
});
